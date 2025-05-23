import 'package:calory_app/domain/entities/meal_item.dart';
import 'package:calory_app/domain/entities/meal_result.dart';

class MealItemModel extends MealItem {
  MealItemModel({
    required int foodId,
    required int weightInGrams,
  }) : super(
          foodId: foodId,
          weightInGrams: weightInGrams,
        );

  factory MealItemModel.fromJson(Map<String, dynamic> json) {
    return MealItemModel(
      foodId: json['foodId'],
      weightInGrams: json['weightInGrams'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'weightInGrams': weightInGrams,
    };
  }
}

class MealItemDetailModel extends MealItemDetail {
  MealItemDetailModel({
    required int foodId,
    required String foodName,
    required int weightInGrams,
    required double calories,
  }) : super(
          foodId: foodId,
          foodName: foodName,
          weightInGrams: weightInGrams,
          calories: calories,
        );

  factory MealItemDetailModel.fromJson(Map<String, dynamic> json) {
    return MealItemDetailModel(
      foodId: json['foodId'],
      foodName: json['foodName'] ?? '',
      weightInGrams: json['weightInGrams'],
      calories: json['calories'].toDouble(),
    );
  }
}

class MealResultModel extends MealResult {
  MealResultModel({
    required double totalCalories,
    required List<MealItemDetail> items,
  }) : super(
          totalCalories: totalCalories,
          items: items,
        );

  factory MealResultModel.fromJson(Map<String, dynamic> json) {
    List<MealItemDetailModel> itemsList = [];
    
    // Check if items exists and is not null
    if (json.containsKey('items') && json['items'] != null) {
      itemsList = (json['items'] as List)
          .map((item) => MealItemDetailModel.fromJson(item))
          .toList();
    }

    return MealResultModel(
      totalCalories: json.containsKey('totalCalories') && json['totalCalories'] != null 
          ? json['totalCalories'].toDouble() 
          : 0.0,
      items: itemsList,
    );
  }
}

class MealRequestDto {
  final List<MealItemModel> items;

  MealRequestDto({
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

// Debugging extension method to visualize dto
extension MealRequestDtoDebug on MealRequestDto {
  String toPrettyJson() {
    final itemsList = items.map((item) => {
      'foodId': item.foodId,
      'weightInGrams': item.weightInGrams
    }).toList();
    
    return 'MealRequestDto: { items: $itemsList }';
  }
} 