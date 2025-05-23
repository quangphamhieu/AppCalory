import 'package:calory_app/data/models/meal_model.dart';
import 'package:calory_app/domain/entities/meal_result.dart';
import 'package:calory_app/domain/usecases/meal_usecases.dart';
import 'package:flutter/foundation.dart';

enum MealStatus {
  initial,
  calculating,
  calculated,
  error,
}

class MealProvider extends ChangeNotifier {
  final CalculateMealUseCase _calculateMealUseCase;
  
  MealStatus _status = MealStatus.initial;
  List<MealItemModel> _mealItems = [];
  MealResult? _mealResult;
  String? _errorMessage;
  
  MealProvider({required CalculateMealUseCase calculateMealUseCase})
      : _calculateMealUseCase = calculateMealUseCase;
  
  MealStatus get status => _status;
  List<MealItemModel> get mealItems => _mealItems;
  MealResult? get mealResult => _mealResult;
  String? get errorMessage => _errorMessage;
  
  void addMealItem(int foodId, int weightInGrams) {
    _mealItems.add(MealItemModel(
      foodId: foodId,
      weightInGrams: weightInGrams,
    ));
    notifyListeners();
  }
  
  void removeMealItem(int index) {
    if (index >= 0 && index < _mealItems.length) {
      _mealItems.removeAt(index);
      notifyListeners();
    }
  }
  
  void updateMealItem(int index, int foodId, int weightInGrams) {
    if (index >= 0 && index < _mealItems.length) {
      _mealItems[index] = MealItemModel(
        foodId: foodId,
        weightInGrams: weightInGrams,
      );
      notifyListeners();
    }
  }
  
  void clearMealItems() {
    _mealItems = [];
    _mealResult = null;
    _status = MealStatus.initial;
    notifyListeners();
  }
  
  Future<bool> calculateMeal() async {
    if (_mealItems.isEmpty) {
      _errorMessage = 'Bạn chưa thêm món ăn nào vào bữa ăn.';
      notifyListeners();
      return false;
    }
    
    _status = MealStatus.calculating;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _mealResult = await _calculateMealUseCase.execute(_mealItems);
      _status = MealStatus.calculated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = MealStatus.error;
      _errorMessage = 'Không thể tính toán dinh dưỡng. Vui lòng thử lại sau.';
      notifyListeners();
      return false;
    }
  }
} 