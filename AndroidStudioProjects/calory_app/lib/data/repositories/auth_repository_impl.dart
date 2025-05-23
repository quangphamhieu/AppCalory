import 'dart:convert';

import 'package:calory_app/core/constants/api_endpoints.dart';
import 'package:calory_app/core/network/token_handler.dart';
import 'package:calory_app/data/models/auth_model.dart';
import 'package:calory_app/domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl implements AuthRepository {
  final TokenHandler _tokenHandler;
  
  AuthRepositoryImpl({required TokenHandler tokenHandler}) : _tokenHandler = tokenHandler;
  
  @override
  Future<AuthResponse> login(LoginModel loginModel) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.login),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(loginModel.toJson()),
      );
      
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);
        final token = jsonData['token'];
        
        await _tokenHandler.addToken(token);
        
        // Decode token to get role
        final decodedToken = _tokenHandler.decodeToken();
        var roleData = decodedToken[
            'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
            
        // Convert roleData to string
        String role = '';
        if (roleData == null) {
          role = '';
        } else if (roleData is List) {
          role = roleData.isNotEmpty ? roleData[0].toString() : '';
        } else {
          role = roleData.toString();
        }
        
        return AuthResponse(token: token, role: role);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Sai thông tin đăng nhập');
      } else if (response.statusCode == 400) {
        throw Exception('BadRequest: Thông tin đăng nhập không hợp lệ');
      } else {
        throw Exception('LoginFailed: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Unauthorized') || 
          e.toString().contains('BadRequest') || 
          e.toString().contains('LoginFailed')) {
        rethrow;
      }
      throw Exception('NetworkError: Lỗi kết nối mạng');
    }
  }
  
  @override
  Future<bool> register(RegisterModel registerModel) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.register),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(registerModel.toJson()),
      );
      
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return true;
      } else if (response.statusCode == 400) {
        // Kiểm tra nội dung lỗi 400 để phân loại
        if (response.body.contains('email')) {
          throw Exception('EmailError: Email đã tồn tại hoặc không hợp lệ');
        } else if (response.body.contains('password')) {
          throw Exception('PasswordError: Mật khẩu không đáp ứng yêu cầu');
        } else {
          throw Exception('RegistrationDataError: Dữ liệu đăng ký không hợp lệ');
        }
      } else {
        throw Exception('RegistrationFailed: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('EmailError') || 
          e.toString().contains('PasswordError') || 
          e.toString().contains('RegistrationDataError') ||
          e.toString().contains('RegistrationFailed')) {
        rethrow;
      }
      throw Exception('NetworkError: Lỗi kết nối mạng');
    }
  }
  
  @override
  Future<void> logout() async {
    await _tokenHandler.clearToken();
  }
  
  @override
  bool isLoggedIn() {
    return _tokenHandler.hasToken();
  }
  
  @override
  String? getToken() {
    return _tokenHandler.getToken();
  }
  
  @override
  String? getRole() {
    final decodedToken = _tokenHandler.decodeToken();
    if (decodedToken.isEmpty) return null;
    
    var roleData = decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
    
    if (roleData == null) {
      return null;
    } else if (roleData is List) {
      return roleData.isNotEmpty ? roleData[0].toString() : null;
    } else {
      return roleData.toString();
    }
  }
  
  @override
  String? getUserEmail() {
    return _tokenHandler.getUserEmail();
  }
  
  @override
  String? getUserId() {
    return _tokenHandler.getUserId();
  }
} 