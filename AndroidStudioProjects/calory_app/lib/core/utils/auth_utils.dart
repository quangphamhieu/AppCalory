import 'package:flutter/material.dart';
import 'package:calory_app/core/network/token_handler.dart';
import 'package:calory_app/presentation/screens/auth/login_screen.dart';

class AuthUtils {
  static String fetchEmailFromToken({required BuildContext context}) {
    if (TokenHandler().getToken().isEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }

    final decodedToken = TokenHandler().decodeToken();
    
    // Lấy email từ token và xử lý trường hợp null
    var emailData = decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'];
    if (emailData == null) {
      // Thử lấy từ claim 'email' nếu có
      emailData = decodedToken['email'];
    }
    
    String email = emailData != null ? emailData.toString() : "";
    
    if (email.isEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }

    return email;
  }

  static void checkAdminRole(BuildContext context) {
    final decodedToken = TokenHandler().decodeToken();
    
    // Lấy role từ token và xử lý các trường hợp khác nhau
    var roleData = decodedToken[
        'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
        
    // Chuyển đổi roleData thành string
    String? role;
    if (roleData == null) {
      role = null;
    } else if (roleData is List) {
      // Nếu là array, lấy phần tử đầu tiên (nếu có)
      role = roleData.isNotEmpty ? roleData[0].toString() : null;
    } else {
      // Nếu là string hoặc kiểu dữ liệu khác, chuyển đổi thành string
      role = roleData.toString();
    }

    if (role != "Admin" || role == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  static void checkUserRole(BuildContext context) {
    final decodedToken = TokenHandler().decodeToken();
    
    // Lấy role từ token và xử lý các trường hợp khác nhau
    var roleData = decodedToken[
        'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
        
    // Chuyển đổi roleData thành string
    String? role;
    if (roleData == null) {
      role = null;
    } else if (roleData is List) {
      // Nếu là array, lấy phần tử đầu tiên (nếu có)
      role = roleData.isNotEmpty ? roleData[0].toString() : null;
    } else {
      // Nếu là string hoặc kiểu dữ liệu khác, chuyển đổi thành string
      role = roleData.toString();
    }

    if (role != "User" || role == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }
} 