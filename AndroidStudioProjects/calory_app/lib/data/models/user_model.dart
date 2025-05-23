import 'package:calory_app/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String email,
    String? phoneNumber,
    double? weight,
    double? height,
    double? bmi,
  }) : super(
          email: email,
          phoneNumber: phoneNumber,
          weight: weight,
          height: height,
          bmi: bmi,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      weight: json['weight'] != null ? double.parse(json['weight'].toString()) : null,
      height: json['height'] != null ? double.parse(json['height'].toString()) : null,
      bmi: json['bmi'] != null ? double.parse(json['bmi'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'weight': weight,
      'height': height,
      'bmi': bmi,
    };
  }
}

class UpdateUserInfoDto {
  final String email;
  final String? phoneNumber;
  final double? weight;
  final double? height;

  UpdateUserInfoDto({
    required this.email,
    this.phoneNumber,
    this.weight,
    this.height,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'weight': weight,
      'height': height,
    };
  }
}

class ChangePasswordDto {
  final String email;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordDto({
    required this.email,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
} 