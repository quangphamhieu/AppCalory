import 'dart:convert';

import 'package:calory_app/core/constants/api_endpoints.dart';
import 'package:calory_app/core/network/token_handler.dart';
import 'package:calory_app/data/models/user_model.dart';
import 'package:calory_app/domain/entities/user.dart';
import 'package:calory_app/domain/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

class UserRepositoryImpl implements UserRepository {
  final TokenHandler _tokenHandler;
  
  UserRepositoryImpl({required TokenHandler tokenHandler}) : _tokenHandler = tokenHandler;

  @override
  Future<User> getUserInfo(String email) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.userInfo),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_tokenHandler.getToken()}',
        },
        body: jsonEncode(email),
      );

      // First attempt - assuming direct string is ok
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);
        return UserModel.fromJson(jsonData);
      } 
      // If first attempt fails, try with a JSON object with email field
      else {
        final secondResponse = await http.post(
          Uri.parse(ApiEndpoints.userInfo),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${_tokenHandler.getToken()}',
          },
          body: jsonEncode({'email': email}),
        );

        if (secondResponse.statusCode >= 200 && secondResponse.statusCode <= 299) {
          final jsonData = json.decode(secondResponse.body);
          return UserModel.fromJson(jsonData);
        } else {
          throw Exception('Failed to load user information: ${secondResponse.body}');
        }
      }
    } catch (e) {
      throw Exception('Error getting user information: $e');
    }
  }

  @override
  Future<bool> updateUserInfo(UpdateUserInfoDto updateUserInfoDto) async {
    try {
      final response = await http.put(
        Uri.parse(ApiEndpoints.updateUserInfo),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_tokenHandler.getToken()}',
        },
        body: jsonEncode(updateUserInfoDto.toJson()),
      );
      
      return response.statusCode >= 200 && response.statusCode <= 299;
    } catch (e) {
      throw Exception('Error updating user information: $e');
    }
  }

  @override
  Future<bool> changePassword(ChangePasswordDto changePasswordDto) async {
    try {
      final response = await http.put(
        Uri.parse(ApiEndpoints.changePassword),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_tokenHandler.getToken()}',
        },
        body: jsonEncode(changePasswordDto.toJson()),
      );

      return response.statusCode >= 200 && response.statusCode <= 299;
    } catch (e) {
      throw Exception('Error changing password: $e');
    }
  }

  @override
  Future<bool> deleteAccount(String email) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiEndpoints.deleteUser}?email=$email'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_tokenHandler.getToken()}',
        },
      );

      return response.statusCode >= 200 && response.statusCode <= 299;
    } catch (e) {
      throw Exception('Error deleting account: $e');
    }
  }
} 