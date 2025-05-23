import 'package:calory_app/data/models/auth_model.dart';
import 'package:calory_app/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<AuthResponse> execute(String email, String password) async {
    final loginModel = LoginModel(email: email, password: password);
    return await authRepository.login(loginModel);
  }
}

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<bool> execute(
    String email, 
    String password, 
    String phoneNumber,
    double weight,
    double height,
  ) async {
    final registerModel = RegisterModel(
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      weight: weight,
      height: height,
    );
    return await authRepository.register(registerModel);
  }
}

class LogoutUseCase {
  final AuthRepository authRepository;

  LogoutUseCase(this.authRepository);

  Future<void> execute() async {
    await authRepository.logout();
  }
}

class CheckAuthStateUseCase {
  final AuthRepository authRepository;

  CheckAuthStateUseCase(this.authRepository);

  bool execute() {
    return authRepository.isLoggedIn();
  }
}

class GetUserRoleUseCase {
  final AuthRepository authRepository;

  GetUserRoleUseCase(this.authRepository);

  String? execute() {
    return authRepository.getRole();
  }
}

class IsAdminUseCase {
  final AuthRepository authRepository;

  IsAdminUseCase(this.authRepository);

  bool execute() {
    final role = authRepository.getRole();
    return role?.toLowerCase() == 'admin';
  }
}

class GetUserEmailUseCase {
  final AuthRepository authRepository;

  GetUserEmailUseCase(this.authRepository);

  String? execute() {
    return authRepository.getUserEmail();
  }
} 