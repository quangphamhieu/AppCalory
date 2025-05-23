import 'package:calory_app/domain/usecases/auth_usecases.dart';
import 'package:flutter/foundation.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStateUseCase _checkAuthStateUseCase;
  final GetUserRoleUseCase _getUserRoleUseCase;
  final IsAdminUseCase _isAdminUseCase;
  final GetUserEmailUseCase _getUserEmailUseCase;
  
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  String? _userRole;
  
  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthStateUseCase checkAuthStateUseCase,
    required GetUserRoleUseCase getUserRoleUseCase,
    required IsAdminUseCase isAdminUseCase,
    required GetUserEmailUseCase getUserEmailUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _checkAuthStateUseCase = checkAuthStateUseCase,
       _getUserRoleUseCase = getUserRoleUseCase,
       _isAdminUseCase = isAdminUseCase,
       _getUserEmailUseCase = getUserEmailUseCase {
    _checkAuthStatus();
  }
  
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get userRole => _userRole;
  
  String? get userEmail => _getUserEmailUseCase.execute();
  
  Future<void> _checkAuthStatus() async {
    if (_checkAuthStateUseCase.execute()) {
      _status = AuthStatus.authenticated;
      _userRole = _getUserRoleUseCase.execute();
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
  
  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final authResponse = await _loginUseCase.execute(email, password);
      
      _userRole = authResponse.role;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      
      if (e.toString().contains('Unauthorized') || e.toString().contains('401')) {
        _errorMessage = 'Sai email hoặc mật khẩu. Vui lòng thử lại.';
      } else if (e.toString().contains('timeout') || e.toString().contains('Connection')) {
        _errorMessage = 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.';
      } else {
        _errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại sau.';
      }
      
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> register({
    required String email,
    required String password,
    required String phoneNumber,
    required double weight,
    required double height,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final success = await _registerUseCase.execute(
        email, 
        password, 
        phoneNumber,
        weight,
        height,
      );
      
      if (success) {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = 'Đăng ký thất bại. Vui lòng thử lại sau.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      
      if (e.toString().contains('email')) {
        _errorMessage = 'Email đã được sử dụng hoặc không hợp lệ.';
      } else if (e.toString().contains('password')) {
        _errorMessage = 'Mật khẩu không đáp ứng yêu cầu. Vui lòng thử mật khẩu khác.';
      } else if (e.toString().contains('timeout') || e.toString().contains('Connection')) {
        _errorMessage = 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.';
      } else {
        _errorMessage = 'Đăng ký thất bại. Vui lòng thử lại sau.';
      }
      
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    await _logoutUseCase.execute();
    _status = AuthStatus.unauthenticated;
    _userRole = null;
    notifyListeners();
  }
  
  bool isAdmin() {
    return _isAdminUseCase.execute();
  }
} 