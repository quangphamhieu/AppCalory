import 'package:calory_app/data/models/meal_model.dart';
import 'package:calory_app/domain/entities/meal_result.dart';

abstract class MealRepository {
  Future<MealResult> calculateMeal(MealRequestDto mealRequestDto);
} 