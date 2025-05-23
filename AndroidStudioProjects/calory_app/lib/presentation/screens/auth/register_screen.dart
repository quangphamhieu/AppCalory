import 'package:calory_app/core/constants/app_colors.dart';
import 'package:calory_app/presentation/providers/auth_provider.dart';
import 'package:calory_app/presentation/widgets/custom_appbar.dart';
import 'package:calory_app/presentation/widgets/custom_buttons.dart';
import 'package:calory_app/presentation/widgets/custom_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Parse weight and height
      double weight;
      double height;
      
      try {
        weight = double.parse(_weightController.text);
        height = double.parse(_heightController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter valid numbers for weight and height'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final success = await authProvider.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phoneNumber: _phoneNumberController.text.trim(),
        weight: weight,
        height: height,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Register',
        color: AppColors.loginPage,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.loginPage.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.loginPage,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Email field
                  emailTextField(emailController: _emailController),
                  const SizedBox(height: 16),
                  
                  // Phone Number field
                  phoneNumberField(phoneNumberController: _phoneNumberController),
                  const SizedBox(height: 16),
                  
                  // Weight and Height row
                  Row(
                    children: [
                      // Weight field
                      Expanded(
                        child: weightTextField(weightController: _weightController),
                      ),
                      const SizedBox(width: 16),
                      // Height field
                      Expanded(
                        child: heightTextField(heightController: _heightController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Password field
                  PasswordVisibilityField(
                    controller: _passwordController,
                    labelText: 'Password',
                    primaryColor: AppColors.loginPage,
                  ),
                  const SizedBox(height: 16),
                  
                  // Confirm Password field
                  PasswordVisibilityField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    primaryColor: AppColors.loginPage,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Error message
                  if (authProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        authProvider.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  // Register button
                  authProvider.status == AuthStatus.authenticating
                      ? const Center(
                          child: CircularProgressIndicator(color: AppColors.loginPage),
                        )
                      : submitButton(
                          context: context,
                          backgroundColor: AppColors.loginPage,
                          textColor: Colors.white,
                          title: 'Register',
                          method: _register,
                        ),
                  const SizedBox(height: 16),
                  
                  // Login link
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.loginPage,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 16, color: AppColors.loginPage),
                        children: const [
                          TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 