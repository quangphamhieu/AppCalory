import 'package:calory_app/data/models/food_model.dart';
import 'package:calory_app/domain/entities/food.dart';

abstract class FoodRepository {
  Future<List<Food>> getAllFoods();
  Future<Food> getFood(int id);
  Future<Food> createFood(CreateFoodDto createFoodDto);
  Future<bool> updateFood(int id, UpdateFoodDto updateFoodDto);
  Future<bool> deleteFood(int id);
} 