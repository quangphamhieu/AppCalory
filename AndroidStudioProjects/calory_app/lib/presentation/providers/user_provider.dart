import 'package:calory_app/domain/entities/user.dart';
import 'package:calory_app/domain/usecases/user_usecases.dart';
import 'package:flutter/foundation.dart';

enum UserStatus {
  initial,
  loading,
  loaded,
  updating,
  error,
}

class UserProvider extends ChangeNotifier {
  final GetUserInfoUseCase _getUserInfoUseCase;
  final UpdateUserInfoUseCase _updateUserInfoUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  
  UserStatus _status = UserStatus.initial;
  User? _user;
  String? _errorMessage;
  
  UserProvider({
    required GetUserInfoUseCase getUserInfoUseCase,
    required UpdateUserInfoUseCase updateUserInfoUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
  }) : _getUserInfoUseCase = getUserInfoUseCase,
       _updateUserInfoUseCase = updateUserInfoUseCase,
       _changePasswordUseCase = changePasswordUseCase,
       _deleteAccountUseCase = deleteAccountUseCase;
  
  UserStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  
  Future<void> getUserInfo(String email) async {
    _status = UserStatus.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _user = await _getUserInfoUseCase.execute(email);
      _status = UserStatus.loaded;
      notifyListeners();
    } catch (e) {
      _status = UserStatus.error;
      _errorMessage = 'Không thể tải thông tin người dùng. Vui lòng thử lại sau.';
      notifyListeners();
    }
  }
  
  Future<bool> updateUserInfo({
    required String email,
    String? phoneNumber,
    double? weight,
    double? height,
  }) async {
    _status = UserStatus.updating;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final success = await _updateUserInfoUseCase.execute(
        email: email,
        phoneNumber: phoneNumber,
        weight: weight,
        height: height,
      );
      
      if (success) {
        await getUserInfo(email);
        return true;
      } else {
        _status = UserStatus.error;
        _errorMessage = 'Cập nhật thông tin thất bại. Vui lòng thử lại sau.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = UserStatus.error;
      if (e.toString().contains('phoneNumber')) {
        _errorMessage = 'Số điện thoại không hợp lệ.';
      } else if (e.toString().contains('weight')) {
        _errorMessage = 'Cân nặng không hợp lệ.';
      } else if (e.toString().contains('height')) {
        _errorMessage = 'Chiều cao không hợp lệ.';
      } else {
        _errorMessage = 'Cập nhật thông tin thất bại. Vui lòng thử lại sau.';
      }
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _status = UserStatus.updating;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final success = await _changePasswordUseCase.execute(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      
      if (success) {
        _status = UserStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = UserStatus.error;
        _errorMessage = 'Đổi mật khẩu thất bại. Vui lòng thử lại sau.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = UserStatus.error;
      if (e.toString().contains('current') || e.toString().contains('password') || e.toString().contains('401')) {
        _errorMessage = 'Mật khẩu hiện tại không đúng.';
      } else if (e.toString().contains('new password') || e.toString().contains('validation')) {
        _errorMessage = 'Mật khẩu mới không đáp ứng yêu cầu. Vui lòng thử lại.';
      } else {
        _errorMessage = 'Đổi mật khẩu thất bại. Vui lòng thử lại sau.';
      }
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> deleteAccount(String email) async {
    _status = UserStatus.updating;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final success = await _deleteAccountUseCase.execute(email);
      
      if (success) {
        _user = null;
        _status = UserStatus.initial;
        notifyListeners();
        return true;
      } else {
        _status = UserStatus.error;
        _errorMessage = 'Xóa tài khoản thất bại. Vui lòng thử lại sau.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = UserStatus.error;
      _errorMessage = 'Xóa tài khoản thất bại. Vui lòng thử lại sau.';
      notifyListeners();
      return false;
    }
  }
} 