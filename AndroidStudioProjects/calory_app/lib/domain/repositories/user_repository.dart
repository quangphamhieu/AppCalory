import 'package:calory_app/data/models/user_model.dart';
import 'package:calory_app/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> getUserInfo(String email);
  Future<bool> updateUserInfo(UpdateUserInfoDto updateUserInfoDto);
  Future<bool> changePassword(ChangePasswordDto changePasswordDto);
  Future<bool> deleteAccount(String email);
} 