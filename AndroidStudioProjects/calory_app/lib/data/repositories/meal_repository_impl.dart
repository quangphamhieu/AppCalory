import 'dart:convert';

import 'package:calory_app/core/constants/api_endpoints.dart';
import 'package:calory_app/core/network/token_handler.dart';
import 'package:calory_app/data/models/meal_model.dart';
import 'package:calory_app/domain/entities/meal_result.dart';
import 'package:calory_app/domain/repositories/meal_repository.dart';
import 'package:http/http.dart' as http;

class MealRepositoryImpl implements MealRepository {
  final TokenHandler _tokenHandler;
  
  MealRepositoryImpl({required TokenHandler tokenHandler}) : _tokenHandler = tokenHandler;
  
  @override
  Future<MealResult> calculateMeal(MealRequestDto mealRequestDto) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.mealCalculate),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_tokenHandler.getToken()}',
        },
        body: jsonEncode(mealRequestDto.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MealResultModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to calculate meal: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error calculating meal: $e');
    }
  }
} 