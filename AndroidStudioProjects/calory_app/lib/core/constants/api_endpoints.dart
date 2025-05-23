class ApiEndpoints {
  static const String baseUrl = 'http://10.0.2.2:5282/api';
  
  // Auth endpoints
  static const String login = '$baseUrl/Account/login';
  static const String register = '$baseUrl/Account/register';
  static const String changePassword = '$baseUrl/Account/change-password';
  static const String forgotPassword = '$baseUrl/Account/forgot-password';
  static const String resetPassword = '$baseUrl/Account/reset-password';
  
  // User endpoints
  static const String userInfo = '$baseUrl/User/user-info';
  static const String updateUserInfo = '$baseUrl/User/user-info'; // PUT method
  static const String deleteUser = '$baseUrl/User/delete-user';
  
  // Food endpoints
  static const String foodGetAll = '$baseUrl/Food/getall';
  static const String foodGet = '$baseUrl/Food/get-by';
  static const String foodCreate = '$baseUrl/Food/create-food';
  static const String foodUpdate = '$baseUrl/Food/update-by';
  static const String foodDelete = '$baseUrl/Food/delete-by';
  
  // Meal endpoints
  static const String mealCalculate = '$baseUrl/Meal/calculate';
} 