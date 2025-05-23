import 'package:calory_app/data/models/auth_model.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginModel loginModel);
  Future<bool> register(RegisterModel registerModel);
  Future<void> logout();
  bool isLoggedIn();
  String? getToken();
  String? getRole();
  String? getUserEmail();
  String? getUserId();
} 