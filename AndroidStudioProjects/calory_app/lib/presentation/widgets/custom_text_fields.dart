import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calory_app/core/constants/border_styles.dart';
import 'package:calory_app/core/constants/app_colors.dart';

TextFormField emailTextField({
  required TextEditingController emailController,
  bool readOnly = false,
  Color primaryColor = AppColors.loginPage,
}) {
  return TextFormField(
    controller: emailController,
    decoration: InputDecoration(
      labelText: "Email",
      floatingLabelStyle: TextStyle(color: primaryColor),
      border: BorderStyles.border,
      focusedBorder: BorderStyles.focusedBorder,
      errorBorder: BorderStyles.errorBorder,
      focusedErrorBorder: BorderStyles.focusedErrorBorder,
      prefixIcon: Icon(Icons.email, color: primaryColor),
    ),
    keyboardType: TextInputType.emailAddress,
    readOnly: readOnly,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your email.';
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
        return 'Please enter a valid email';
      }
      return null;
    },
  );
}

TextFormField passwordTextField({
  required TextEditingController passwordController,
  String? label,
}) {
  return TextFormField(
    controller: passwordController,
    decoration: InputDecoration(
      labelText: label ?? "Password",
      floatingLabelStyle: const TextStyle(color: Colors.green),
      border: BorderStyles.border,
      focusedBorder: BorderStyles.focusedBorder,
      errorBorder: BorderStyles.errorBorder,
      focusedErrorBorder: BorderStyles.focusedErrorBorder,
    ),
    obscureText: true,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your password.';
      }
      if (value.length < 6) {
        return "Password must be at least 6 characters";
      }
      return null;
    },
  );
}

class PasswordVisibilityField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final Color primaryColor;

  const PasswordVisibilityField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.primaryColor = Colors.green,
  }) : super(key: key);

  @override
  State<PasswordVisibilityField> createState() => _PasswordVisibilityFieldState();
}

class _PasswordVisibilityFieldState extends State<PasswordVisibilityField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        floatingLabelStyle: TextStyle(color: widget.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.lock, color: widget.primaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: widget.primaryColor, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isVisible ? Icons.visibility_off : Icons.visibility,
            color: widget.primaryColor,
          ),
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
        ),
      ),
      obscureText: !_isVisible,
      validator: widget.validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}

TextFormField phoneNumberField({
  required TextEditingController phoneNumberController,
  Color primaryColor = AppColors.loginPage,
}) {
  return TextFormField(
    controller: phoneNumberController,
    decoration: InputDecoration(
      labelText: "Phone Number",
      floatingLabelStyle: TextStyle(color: primaryColor),
      border: BorderStyles.border,
      focusedBorder: BorderStyles.focusedBorder,
      errorBorder: BorderStyles.errorBorder,
      focusedErrorBorder: BorderStyles.focusedErrorBorder,
      prefixIcon: Icon(Icons.phone, color: primaryColor),
    ),
    keyboardType: TextInputType.phone,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
    ],
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your phone number.';
      }
      if (value.length < 7) {
        return "Phone number must be at least 7 characters";
      }
      return null;
    },
  );
}

// Thêm 2 hàm nhập cho weight và height:
TextFormField weightTextField({
  required TextEditingController weightController,
  Color primaryColor = AppColors.loginPage,
}) {
  return TextFormField(
    controller: weightController,
    decoration: InputDecoration(
      labelText: "Weight (kg)",
      floatingLabelStyle: TextStyle(color: primaryColor),
      border: BorderStyles.border,
      focusedBorder: BorderStyles.focusedBorder,
      errorBorder: BorderStyles.errorBorder,
      focusedErrorBorder: BorderStyles.focusedErrorBorder,
      prefixIcon: Icon(Icons.monitor_weight, color: primaryColor),
    ),
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    ],
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your weight.';
      }
      if (double.tryParse(value) == null || double.parse(value) <= 0) {
        return 'Please enter a valid weight.';
      }
      return null;
    },
  );
}

TextFormField heightTextField({
  required TextEditingController heightController,
  Color primaryColor = AppColors.loginPage,
}) {
  return TextFormField(
    controller: heightController,
    decoration: InputDecoration(
      labelText: "Height (m)",
      floatingLabelStyle: TextStyle(color: primaryColor),
      border: BorderStyles.border,
      focusedBorder: BorderStyles.focusedBorder,
      errorBorder: BorderStyles.errorBorder,
      focusedErrorBorder: BorderStyles.focusedErrorBorder,
      prefixIcon: Icon(Icons.height, color: primaryColor),
    ),
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    ],
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your height.';
      }
      if (double.tryParse(value) == null || double.parse(value) <= 0) {
        return 'Please enter a valid height.';
      }
      return null;
    },
  );
}

TextField userDetailsTextField({
  required String label,
  required String value,
}) {
  return TextField(
    controller: TextEditingController(text: value),
    readOnly: true,
    decoration: InputDecoration(
      labelText: label,
      floatingLabelStyle: const TextStyle(color: Colors.green),
      border: BorderStyles.border,
      focusedBorder: BorderStyles.focusedBorder,
      errorBorder: BorderStyles.errorBorder,
      focusedErrorBorder: BorderStyles.focusedErrorBorder,
    ),
  );
} 