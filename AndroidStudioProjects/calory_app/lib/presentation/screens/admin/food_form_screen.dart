import 'package:calory_app/core/constants/app_colors.dart';
import 'package:calory_app/domain/entities/food.dart';
import 'package:calory_app/presentation/providers/food_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodFormScreen extends StatefulWidget {
  final bool isEditing;
  final Food? food;

  const FoodFormScreen({
    Key? key,
    this.isEditing = false,
    this.food,
  }) : super(key: key);

  @override
  State<FoodFormScreen> createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends State<FoodFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.food != null) {
      _nameController.text = widget.food!.name;
      _caloriesController.text = widget.food!.caloriesPer100g.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _saveFood() async {
    if (_formKey.currentState!.validate()) {
      final foodProvider = Provider.of<FoodProvider>(context, listen: false);
      bool success;

      if (widget.isEditing && widget.food != null) {
        success = await foodProvider.updateFood(
          id: widget.food!.id,
          name: _nameController.text.trim(),
          caloriesPer100g: int.parse(_caloriesController.text),
        );
      } else {
        success = await foodProvider.createFood(
          name: _nameController.text.trim(),
          caloriesPer100g: int.parse(_caloriesController.text),
        );
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing ? 'Food updated successfully' : 'Food created successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final isLoading = foodProvider.status == FoodStatus.creating || 
                      foodProvider.status == FoodStatus.updating;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Food' : 'Add Food'),
        backgroundColor: AppColors.adminPage,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a food name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Calories per 100g',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_fire_department),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter calories';
                  }
                  try {
                    final calories = int.parse(value);
                    if (calories <= 0) {
                      return 'Calories must be greater than 0';
                    }
                  } catch (e) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (foodProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    foodProvider.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ElevatedButton(
                onPressed: isLoading ? null : _saveFood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.adminPage,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.isEditing ? 'Update Food' : 'Add Food'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 