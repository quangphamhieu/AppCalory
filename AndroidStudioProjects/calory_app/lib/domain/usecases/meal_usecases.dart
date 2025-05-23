import 'package:calory_app/data/models/meal_model.dart';
import 'package:calory_app/domain/entities/meal_result.dart';
import 'package:calory_app/domain/repositories/meal_repository.dart';

class CalculateMealUseCase {
  final MealRepository mealRepository;

  CalculateMealUseCase(this.mealRepository);

  Future<MealResult> execute(List<MealItemModel> mealItems) async {
    final mealRequestDto = MealRequestDto(items: mealItems);
    return await mealRepository.calculateMeal(mealRequestDto);
  }
} 