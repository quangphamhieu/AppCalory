class MealResult {
  final double totalCalories;
  final List<MealItemDetail> items;

  MealResult({
    required this.totalCalories,
    required this.items,
  });
}

class MealItemDetail {
  final int foodId;
  final String foodName;
  final int weightInGrams;
  final double calories;

  MealItemDetail({
    required this.foodId,
    required this.foodName,
    required this.weightInGrams,
    required this.calories,
  });
} 