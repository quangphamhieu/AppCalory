import 'package:calory_app/data/models/food_model.dart';
import 'package:calory_app/domain/entities/food.dart';
import 'package:calory_app/domain/usecases/food_usecases.dart';
import 'package:flutter/foundation.dart';

enum FoodStatus {
  initial,
  loading,
  loaded,
  creating,
  updating,
  deleting,
  error,
}

class FoodProvider extends ChangeNotifier {
  final GetAllFoodsUseCase _getAllFoodsUseCase;
  final GetFoodUseCase _getFoodUseCase;
  final CreateFoodUseCase _createFoodUseCase;
  final UpdateFoodUseCase _updateFoodUseCase;
  final DeleteFoodUseCase _deleteFoodUseCase;
  
  FoodStatus _status = FoodStatus.initial;
  List<Food> _foods = [];
  Food? _selectedFood;
  String? _errorMessage;
  
  FoodProvider({
    required GetAllFoodsUseCase getAllFoodsUseCase,
    required GetFoodUseCase getFoodUseCase,
    required CreateFoodUseCase createFoodUseCase,
    required UpdateFoodUseCase updateFoodUseCase,
    required DeleteFoodUseCase deleteFoodUseCase,
  }) : _getAllFoodsUseCase = getAllFoodsUseCase,
       _getFoodUseCase = getFoodUseCase,
       _createFoodUseCase = createFoodUseCase,
       _updateFoodUseCase = updateFoodUseCase,
       _deleteFoodUseCase = deleteFoodUseCase;
  
  FoodStatus get status => _status;
  List<Food> get foods => _foods;
  Food? get selectedFood => _selectedFood;
  String? get errorMessage => _errorMessage;
  
  Future<void> getAllFoods() async {
    _status = FoodStatus.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _foods = await _getAllFoodsUseCase.execute();
      _status = FoodStatus.loaded;
      notifyListeners();
    } catch (e) {
      _status = FoodStatus.error;
      _errorMessage = 'Không thể tải danh sách thực phẩm. Vui lòng thử lại sau.';
      notifyListeners();
    }
  }
  
  Future<void> getFood(int id) async {
    _status = FoodStatus.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _selectedFood = await _getFoodUseCase.execute(id);
      _status = FoodStatus.loaded;
      notifyListeners();
    } catch (e) {
      _status = FoodStatus.error;
      _errorMessage = 'Không thể tải thông tin thực phẩm. Vui lòng thử lại sau.';
      notifyListeners();
    }
  }
  
  Future<bool> createFood({required String name, required int caloriesPer100g}) async {
    _status = FoodStatus.creating;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final newFood = await _createFoodUseCase.execute(name, caloriesPer100g);
      _foods.add(newFood);
      _status = FoodStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _status = FoodStatus.error;
      
      if (e.toString().contains('name')) {
        _errorMessage = 'Tên thực phẩm đã tồn tại hoặc không hợp lệ.';
      } else if (e.toString().contains('calories')) {
        _errorMessage = 'Giá trị dinh dưỡng không hợp lệ.';
      } else {
        _errorMessage = 'Không thể tạo thực phẩm mới. Vui lòng thử lại sau.';
      }
      
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> updateFood({required int id, required String name, required int caloriesPer100g}) async {
    _status = FoodStatus.updating;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final success = await _updateFoodUseCase.execute(id, name, caloriesPer100g);
      
      if (success) {
        // Update the food in the local list
        final index = _foods.indexWhere((food) => food.id == id);
        if (index != -1) {
          _foods[index] = FoodModel(
            id: id,
            name: name,
            caloriesPer100g: caloriesPer100g,
          );
        }
        
        _status = FoodStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = FoodStatus.error;
        _errorMessage = 'Không thể cập nhật thực phẩm. Vui lòng thử lại sau.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = FoodStatus.error;
      
      if (e.toString().contains('name')) {
        _errorMessage = 'Tên thực phẩm đã tồn tại hoặc không hợp lệ.';
      } else if (e.toString().contains('calories')) {
        _errorMessage = 'Giá trị dinh dưỡng không hợp lệ.';
      } else {
        _errorMessage = 'Không thể cập nhật thực phẩm. Vui lòng thử lại sau.';
      }
      
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> deleteFood(int id) async {
    _status = FoodStatus.deleting;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final success = await _deleteFoodUseCase.execute(id);
      
      if (success) {
        _foods.removeWhere((food) => food.id == id);
        _status = FoodStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = FoodStatus.error;
        _errorMessage = 'Không thể xóa thực phẩm. Vui lòng thử lại sau.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = FoodStatus.error;
      _errorMessage = 'Không thể xóa thực phẩm. Vui lòng thử lại sau.';
      notifyListeners();
      return false;
    }
  }
} 