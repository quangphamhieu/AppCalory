import 'package:calory_app/core/constants/app_colors.dart';
import 'package:calory_app/presentation/providers/auth_provider.dart';
import 'package:calory_app/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      if (user != null) {
        _phoneController.text = user.phoneNumber ?? '';
        _weightController.text = user.weight?.toString() ?? '';
        _heightController.text = user.height?.toString() ?? '';
      }
    });
  }
  
  @override
  void dispose() {
    _phoneController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final email = authProvider.userEmail;
      
      if (email == null || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to identify user email. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final success = await userProvider.updateUserInfo(
        email: email,
        phoneNumber: _phoneController.text.trim(),
        weight: _weightController.text.isNotEmpty 
            ? double.parse(_weightController.text) 
            : null,
        height: _heightController.text.isNotEmpty 
            ? double.parse(_heightController.text) 
            : null,
      );
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userProvider.errorMessage ?? 'Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: AppColors.userPage,
      ),
      body: userProvider.status == UserStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text('Failed to load user information'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Personal Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue: user.email,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  readOnly: true,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.phone),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _weightController,
                                  decoration: const InputDecoration(
                                    labelText: 'Weight (kg)',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.monitor_weight),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      try {
                                        final weight = double.parse(value);
                                        if (weight <= 0) {
                                          return 'Weight must be greater than 0';
                                        }
                                      } catch (e) {
                                        return 'Please enter a valid number';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _heightController,
                                  decoration: const InputDecoration(
                                    labelText: 'Height (m)',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.height),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      try {
                                        final height = double.parse(value);
                                        if (height <= 0) {
                                          return 'Height must be greater than 0';
                                        }
                                        if (height > 3) {
                                          return 'Please enter height in meters (e.g., 1.75)';
                                        }
                                      } catch (e) {
                                        return 'Please enter a valid number';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (user.bmi != null)
                          Card(
                            elevation: 4,
                            color: Colors.blue.shade50,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Health Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('BMI:'),
                                      Text(
                                        user.bmi != null 
                                          ? user.bmi!.toStringAsFixed(1)
                                          : user.weight != null && user.height != null && user.height! > 0
                                            ? (user.weight! / (user.height! * user.height!)).toStringAsFixed(1)
                                            : 'N/A',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('BMI Category:'),
                                      Text(
                                        _getBmiCategory(
                                          user.bmi != null 
                                            ? user.bmi!
                                            : user.weight != null && user.height != null && user.height! > 0
                                              ? (user.weight! / (user.height! * user.height!))
                                              : 0
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _getBmiCategoryColor(
                                            user.bmi != null 
                                              ? user.bmi!
                                              : user.weight != null && user.height != null && user.height! > 0
                                                ? (user.weight! / (user.height! * user.height!))
                                                : 0
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        if (userProvider.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              userProvider.errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ElevatedButton(
                          onPressed: userProvider.status == UserStatus.updating
                              ? null
                              : _updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.userPage,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: userProvider.status == UserStatus.updating
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Update Profile'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
  
  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 25) {
      return 'Normal';
    } else if (bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }
  
  Color _getBmiCategoryColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi < 25) {
      return Colors.green;
    } else if (bmi < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
} 