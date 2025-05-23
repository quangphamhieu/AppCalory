import 'package:calory_app/data/models/user_model.dart';
import 'package:calory_app/domain/entities/user.dart';
import 'package:calory_app/domain/repositories/user_repository.dart';

class GetUserInfoUseCase {
  final UserRepository userRepository;

  GetUserInfoUseCase(this.userRepository);

  Future<User> execute(String email) async {
    return await userRepository.getUserInfo(email);
  }
}

class UpdateUserInfoUseCase {
  final UserRepository userRepository;

  UpdateUserInfoUseCase(this.userRepository);

  Future<bool> execute({
    required String email,
    String? phoneNumber,
    double? weight,
    double? height,
  }) async {
    final updateUserInfoDto = UpdateUserInfoDto(
      email: email,
      phoneNumber: phoneNumber,
      weight: weight,
      height: height,
    );
    return await userRepository.updateUserInfo(updateUserInfoDto);
  }
}

class ChangePasswordUseCase {
  final UserRepository userRepository;

  ChangePasswordUseCase(this.userRepository);

  Future<bool> execute({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final changePasswordDto = ChangePasswordDto(
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    return await userRepository.changePassword(changePasswordDto);
  }
}

class DeleteAccountUseCase {
  final UserRepository userRepository;

  DeleteAccountUseCase(this.userRepository);

  Future<bool> execute(String email) async {
    return await userRepository.deleteAccount(email);
  }
} 