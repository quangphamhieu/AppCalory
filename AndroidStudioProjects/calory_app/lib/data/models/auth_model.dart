class LoginModel {
  final String email;
  final String password;

  LoginModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterModel {
  final String email;
  final String password;
  final String phoneNumber;
  final double weight;
  final double height;

  RegisterModel({
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'weight': weight,
      'height': height,
    };
  }
}

class AuthResponse {
  final String token;
  final String role;

  AuthResponse({
    required this.token,
    required this.role,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      role: json['role'] ?? '',
    );
  }
} 