import 'package:calory_app/data/models/food_model.dart';
import 'package:calory_app/domain/entities/food.dart';
import 'package:calory_app/domain/repositories/food_repository.dart';

class GetAllFoodsUseCase {
  final FoodRepository foodRepository;

  GetAllFoodsUseCase(this.foodRepository);

  Future<List<Food>> execute() async {
    return await foodRepository.getAllFoods();
  }
}

class GetFoodUseCase {
  final FoodRepository foodRepository;

  GetFoodUseCase(this.foodRepository);

  Future<Food> execute(int id) async {
    return await foodRepository.getFood(id);
  }
}

class CreateFoodUseCase {
  final FoodRepository foodRepository;

  CreateFoodUseCase(this.foodRepository);

  Future<Food> execute(String name, int caloriesPer100g) async {
    final createFoodDto = CreateFoodDto(
      name: name,
      caloriesPer100g: caloriesPer100g,
    );
    return await foodRepository.createFood(createFoodDto);
  }
}

class UpdateFoodUseCase {
  final FoodRepository foodRepository;

  UpdateFoodUseCase(this.foodRepository);

  Future<bool> execute(int id, String name, int caloriesPer100g) async {
    final updateFoodDto = UpdateFoodDto(
      id: id,
      name: name,
      caloriesPer100g: caloriesPer100g,
    );
    return await foodRepository.updateFood(id, updateFoodDto);
  }
}

class DeleteFoodUseCase {
  final FoodRepository foodRepository;

  DeleteFoodUseCase(this.foodRepository);

  Future<bool> execute(int id) async {
    return await foodRepository.deleteFood(id);
  }
} 