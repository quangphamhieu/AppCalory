import 'package:calory_app/core/constants/app_colors.dart';
import 'package:calory_app/data/models/food_model.dart';
import 'package:calory_app/domain/entities/food.dart';
import 'package:calory_app/domain/entities/user.dart';
import 'package:calory_app/presentation/providers/auth_provider.dart';
import 'package:calory_app/presentation/providers/food_provider.dart';
import 'package:calory_app/presentation/providers/meal_provider.dart';
import 'package:calory_app/presentation/providers/user_provider.dart';
import 'package:calory_app/presentation/screens/auth/login_screen.dart';
import 'package:calory_app/presentation/screens/user/user_profile_screen.dart';
import 'package:calory_app/presentation/screens/user/change_password_screen.dart';
import 'package:calory_app/presentation/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _weightController = TextEditingController();
  int? _selectedFoodId;
  String _searchQuery = '';
  int _selectedIndex = 0; // 0: Meal Calculator, 1: User Profile
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load foods when screen initializes
      Provider.of<FoodProvider>(context, listen: false).getAllFoods();
      
      // Get user info using multiple approaches
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Try using email from token claims
    final email = authProvider.userEmail;
    
    if (email != null && email.isNotEmpty) {
      try {
        await userProvider.getUserInfo(email);
        // If we successfully got user info, we're done
        if (userProvider.user != null) return;
      } catch (e) {
        // Silent error handling
      }
    }
    
    // If that didn't work, try using userId from token
    final userId = authProvider.userRole;
    if (userId != null && userId.isNotEmpty) {
      try {
        await userProvider.getUserInfo(userId);
      } catch (e) {
        // Silent error handling
      }
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _addMealItem() {
    if (_selectedFoodId != null && _weightController.text.isNotEmpty) {
      try {
        final weightInGrams = int.parse(_weightController.text);
        if (weightInGrams > 0) {
          Provider.of<MealProvider>(context, listen: false)
              .addMealItem(_selectedFoodId!, weightInGrams);
          
          setState(() {
            _selectedFoodId = null;
            _weightController.clear();
          });
        } else {
          _showErrorSnackBar('Weight must be greater than 0');
        }
      } catch (e) {
        _showErrorSnackBar('Please enter a valid number for weight');
      }
    } else {
      _showErrorSnackBar('Please select a food and enter weight');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _calculateMeal() async {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    if (mealProvider.mealItems.isEmpty) {
      _showErrorSnackBar('Please add at least one food item');
      return;
    }
    
    try {
      final success = await mealProvider.calculateMeal();
      if (!success && mounted) {
        _showErrorSnackBar(mealProvider.errorMessage ?? 'Failed to calculate meal');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error calculating meal: ${e.toString()}');
      }
    }
  }

  void _logout() async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final mealProvider = Provider.of<MealProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    
    // Filter foods based on search query
    List<Food> filteredFoods = foodProvider.foods;
    if (_searchQuery.isNotEmpty) {
      filteredFoods = filteredFoods
          .where((food) => food.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: CustomAppbar(
        title: _selectedIndex == 0 ? 'Meal Calculator' : 'User Profile',
        color: AppColors.userPage,
      ),
      drawer: _buildDrawer(user),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.userPage.withAlpha((0.2 * 255).toInt()),
              Colors.white,
            ],
          ),
        ),
        child: _selectedIndex == 0 
            ? _buildMealCalculatorView(filteredFoods, mealProvider, foodProvider, userProvider)
            : _buildUserProfileView(user),
      ),
    );
  }
  
  Widget _buildDrawer(User? user) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.userPage),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: AppColors.userPage,
              ),
            ),
            accountName: Text(
              user?.email ?? 'User',
              style: const TextStyle(fontSize: 18),
            ),
            accountEmail: Text(
              'BMI: ${user?.bmi?.toStringAsFixed(1) ?? 'N/A'}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Meal Calculator'),
            selected: _selectedIndex == 0,
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pop(context); // Close drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User Profile'),
            selected: _selectedIndex == 1,
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
              Navigator.pop(context); // Close drawer
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              _logout();
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildMealCalculatorView(
    List<Food> filteredFoods,
    MealProvider mealProvider,
    FoodProvider foodProvider,
    UserProvider userProvider,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Food to Meal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.userPage,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Search Foods',
                        prefixIcon: const Icon(Icons.search, color: AppColors.userPage),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.userPage, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Food',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: filteredFoods.isEmpty
                          ? const Center(child: Text('No foods found'))
                          : ListView.separated(
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemCount: filteredFoods.length,
                              itemBuilder: (context, index) {
                                final food = filteredFoods[index];
                                return Material(
                                  color: _selectedFoodId == food.id 
                                      ? AppColors.userPage.withAlpha(26)
                                      : Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedFoodId = food.id;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, 
                                        vertical: 12.0
                                      ),
                                      child: Row(
                                        children: [
                                          Radio<int>(
                                            value: food.id,
                                            groupValue: _selectedFoodId,
                                            activeColor: AppColors.userPage,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedFoodId = value;
                                              });
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  food.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '${food.caloriesPer100g} cal/100g',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _weightController,
                      decoration: InputDecoration(
                        labelText: 'Weight (grams)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.userPage, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _addMealItem,
                      icon: const Icon(Icons.add),
                      label: const Text('Add to Meal'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.userPage,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meal Items',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.userPage,
                  ),
                ),
                if (mealProvider.mealItems.isNotEmpty)
                  ElevatedButton(
                    onPressed: _calculateMeal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.userPage,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Calculate'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            mealProvider.mealItems.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Text(
                        'No items added to meal yet',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mealProvider.mealItems.length,
                    itemBuilder: (context, index) {
                      final mealItem = mealProvider.mealItems[index];
                      final food = foodProvider.foods.firstWhere(
                        (food) => food.id == mealItem.foodId,
                        orElse: () => FoodModel(
                          id: 0,
                          name: 'Unknown',
                          caloriesPer100g: 0,
                        ),
                      );
                      
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          title: Text(
                            food.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${mealItem.weightInGrams}g (${(food.caloriesPer100g * mealItem.weightInGrams / 100).toStringAsFixed(1)} calories)',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              Provider.of<MealProvider>(context, listen: false)
                                  .removeMealItem(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
            
            // Display meal calculation result
            if (mealProvider.mealResult != null)
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(top: 16, bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: AppColors.userPage.withAlpha((0.1 * 255).toInt()),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Meal Calculation Result',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.userPage,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Calories: ${mealProvider.mealResult!.totalCalories}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Display calorie recommendation based on BMI
            if (userProvider.user?.bmi != null)
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(top: 0, bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: AppColors.userPage.withAlpha((0.1 * 255).toInt()),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Khuyến nghị lượng calo dựa trên BMI',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCalorieRecommendation(userProvider.user!.bmi!),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCalorieRecommendation(double bmi) {
    String target;
    String dailyCalories;
    String mealCalories;
    String mealDistribution;
    
    if (bmi < 18.5) {
      target = 'Tăng cân';
      dailyCalories = '2200 – 2600';
      mealCalories = '730 – 870 kcal';
      mealDistribution = '700 – 900 – 800';
    } else if (bmi >= 18.5 && bmi < 25) {
      target = 'Duy trì cân nặng';
      dailyCalories = '1800 – 2200';
      mealCalories = '600 – 730 kcal';
      mealDistribution = '600 – 800 – 700';
    } else {
      target = 'Giảm cân';
      dailyCalories = '1500 – 1800';
      mealCalories = '500 – 600 kcal';
      mealDistribution = '500 – 700 – 600';
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              const TextSpan(
                text: 'BMI của bạn: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '${bmi.toStringAsFixed(1)}'),
            ],
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              const TextSpan(
                text: 'Mục tiêu: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: target),
            ],
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              const TextSpan(
                text: 'Tổng calo/ngày: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '$dailyCalories kcal'),
            ],
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              const TextSpan(
                text: 'Mỗi bữa (trung bình): ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: mealCalories),
            ],
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              const TextSpan(
                text: 'Gợi ý chia theo bữa (Sáng – Trưa – Tối): ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: mealDistribution),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildUserProfileView(User? user) {
    if (user == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.userPage),
            SizedBox(height: 16),
            Text("Loading user profile...", style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.userPage,
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          _buildUserInfoCard(user),
          const SizedBox(height: 32),
          _buildActionButtons(),
        ],
      ),
    );
  }
  
  Widget _buildUserInfoCard(User user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "User Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.userPage,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow("Email", user.email),
            const Divider(),
            _buildInfoRow("Phone", user.phoneNumber ?? "Not provided"),
            const Divider(),
            _buildInfoRow("Weight", "${user.weight?.toString() ?? 'Not set'} kg"),
            const Divider(),
            _buildInfoRow("Height", "${user.height?.toString() ?? 'Not set'} m"),
            const Divider(),
            _buildInfoRow("BMI", user.bmi?.toStringAsFixed(1) ?? "Not calculated"),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const UserProfileScreen(),
              )
            );
          },
          icon: const Icon(Icons.edit),
          label: const Text("Edit Profile"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.userPage,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              )
            );
          },
          icon: const Icon(Icons.lock),
          label: const Text("Change Password"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.userPage,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
} 