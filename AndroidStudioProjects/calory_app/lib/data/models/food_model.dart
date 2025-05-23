import 'package:calory_app/domain/entities/food.dart';

class FoodModel extends Food {
  FoodModel({
    required int id,
    required String name,
    required int caloriesPer100g,
  }) : super(
          id: id,
          name: name,
          caloriesPer100g: caloriesPer100g,
        );

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      name: json['name'] ?? '',
      caloriesPer100g: json['caloriesPer100g'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'caloriesPer100g': caloriesPer100g,
    };
  }
}

class CreateFoodDto {
  final String name;
  final int caloriesPer100g;

  CreateFoodDto({
    required this.name,
    required this.caloriesPer100g,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'caloriesPer100g': caloriesPer100g,
    };
  }
}

class UpdateFoodDto {
  final int id;
  final String name;
  final int caloriesPer100g;

  UpdateFoodDto({
    required this.id,
    required this.name,
    required this.caloriesPer100g,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'caloriesPer100g': caloriesPer100g,
    };
  }
} 