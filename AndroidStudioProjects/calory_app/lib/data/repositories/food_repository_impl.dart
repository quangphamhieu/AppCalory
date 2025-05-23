import 'dart:convert';

import 'package:calory_app/core/constants/api_endpoints.dart';
import 'package:calory_app/core/network/token_handler.dart';
import 'package:calory_app/data/models/food_model.dart';
import 'package:calory_app/domain/entities/food.dart';
import 'package:calory_app/domain/repositories/food_repository.dart';
import 'package:http/http.dart' as http;

class FoodRepositoryImpl implements FoodRepository {
  final TokenHandler _tokenHandler;
  
  FoodRepositoryImpl({required TokenHandler tokenHandler}) : _tokenHandler = tokenHandler;
  
  @override
  Future<List<Food>> getAllFoods() async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.foodGetAll),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_tokenHandler.getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => FoodModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load foods: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting foods: $e');
    }
  }

  @override
  Future<Food> getFood(int id) async {
    try {
      final url = Uri.parse('${ApiEndpoints.foodGet}/$id');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_tokenHandler.getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return FoodModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load food: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting food: $e');
    }
  }

  @override
  Future<Food> createFood(CreateFoodDto createFoodDto) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.foodCreate),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_tokenHandler.getToken()}',
        },
        body: jsonEncode(createFoodDto.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);
        return FoodModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to create food: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating food: $e');
    }
  }

  @override
  Future<bool> updateFood(int id, UpdateFoodDto updateFoodDto) async {
    try {
      final url = Uri.parse('${ApiEndpoints.foodUpdate}/$id');
      
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_tokenHandler.getToken()}',
        },
        body: jsonEncode(updateFoodDto.toJson()),
      );

      return response.statusCode >= 200 && response.statusCode <= 299;
    } catch (e) {
      throw Exception('Error updating food: $e');
    }
  }

  @override
  Future<bool> deleteFood(int id) async {
    try {
      final url = Uri.parse('${ApiEndpoints.foodDelete}/$id');
      
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_tokenHandler.getToken()}',
        },
      );

      return response.statusCode >= 200 && response.statusCode <= 299;
    } catch (e) {
      throw Exception('Error deleting food: $e');
    }
  }
} 