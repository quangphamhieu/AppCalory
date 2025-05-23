class User {
  final String email;
  final String? phoneNumber;
  final double? weight;
  final double? height;
  final double? bmi;

  User({
    required this.email,
    this.phoneNumber,
    this.weight,
    this.height,
    this.bmi,
  });
} 