import 'package:calory_app/core/network/token_handler.dart';
import 'package:calory_app/data/repositories/auth_repository_impl.dart';
import 'package:calory_app/data/repositories/food_repository_impl.dart';
import 'package:calory_app/data/repositories/meal_repository_impl.dart';
import 'package:calory_app/data/repositories/user_repository_impl.dart';
import 'package:calory_app/domain/repositories/auth_repository.dart';
import 'package:calory_app/domain/repositories/food_repository.dart';
import 'package:calory_app/domain/repositories/meal_repository.dart';
import 'package:calory_app/domain/repositories/user_repository.dart';
import 'package:calory_app/domain/usecases/auth_usecases.dart';
import 'package:calory_app/domain/usecases/food_usecases.dart';
import 'package:calory_app/domain/usecases/meal_usecases.dart';
import 'package:calory_app/domain/usecases/user_usecases.dart';
import 'package:calory_app/presentation/providers/auth_provider.dart';
import 'package:calory_app/presentation/providers/food_provider.dart';
import 'package:calory_app/presentation/providers/meal_provider.dart';
import 'package:calory_app/presentation/providers/user_provider.dart';
import 'package:calory_app/presentation/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize token handler
  final tokenHandler = TokenHandler();
  await tokenHandler.init();
  
  // Initialize repositories
  final AuthRepository authRepository = AuthRepositoryImpl(tokenHandler: tokenHandler);
  final UserRepository userRepository = UserRepositoryImpl(tokenHandler: tokenHandler);
  final FoodRepository foodRepository = FoodRepositoryImpl(tokenHandler: tokenHandler);
  final MealRepository mealRepository = MealRepositoryImpl(tokenHandler: tokenHandler);
  
  // Initialize use cases
  // Auth use cases
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);
  final logoutUseCase = LogoutUseCase(authRepository);
  final checkAuthStateUseCase = CheckAuthStateUseCase(authRepository);
  final getUserRoleUseCase = GetUserRoleUseCase(authRepository);
  final isAdminUseCase = IsAdminUseCase(authRepository);
  final getUserEmailUseCase = GetUserEmailUseCase(authRepository);
  
  // User use cases
  final getUserInfoUseCase = GetUserInfoUseCase(userRepository);
  final updateUserInfoUseCase = UpdateUserInfoUseCase(userRepository);
  final changePasswordUseCase = ChangePasswordUseCase(userRepository);
  final deleteAccountUseCase = DeleteAccountUseCase(userRepository);
  
  // Food use cases
  final getAllFoodsUseCase = GetAllFoodsUseCase(foodRepository);
  final getFoodUseCase = GetFoodUseCase(foodRepository);
  final createFoodUseCase = CreateFoodUseCase(foodRepository);
  final updateFoodUseCase = UpdateFoodUseCase(foodRepository);
  final deleteFoodUseCase = DeleteFoodUseCase(foodRepository);
  
  // Meal use cases
  final calculateMealUseCase = CalculateMealUseCase(mealRepository);
  
  runApp(MyApp(
    loginUseCase: loginUseCase,
    registerUseCase: registerUseCase,
    logoutUseCase: logoutUseCase,
    checkAuthStateUseCase: checkAuthStateUseCase,
    getUserRoleUseCase: getUserRoleUseCase,
    isAdminUseCase: isAdminUseCase,
    getUserEmailUseCase: getUserEmailUseCase,
    getUserInfoUseCase: getUserInfoUseCase,
    updateUserInfoUseCase: updateUserInfoUseCase,
    changePasswordUseCase: changePasswordUseCase,
    deleteAccountUseCase: deleteAccountUseCase,
    getAllFoodsUseCase: getAllFoodsUseCase,
    getFoodUseCase: getFoodUseCase,
    createFoodUseCase: createFoodUseCase,
    updateFoodUseCase: updateFoodUseCase,
    deleteFoodUseCase: deleteFoodUseCase,
    calculateMealUseCase: calculateMealUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStateUseCase checkAuthStateUseCase;
  final GetUserRoleUseCase getUserRoleUseCase;
  final IsAdminUseCase isAdminUseCase;
  final GetUserEmailUseCase getUserEmailUseCase;
  final GetUserInfoUseCase getUserInfoUseCase;
  final UpdateUserInfoUseCase updateUserInfoUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final GetAllFoodsUseCase getAllFoodsUseCase;
  final GetFoodUseCase getFoodUseCase;
  final CreateFoodUseCase createFoodUseCase;
  final UpdateFoodUseCase updateFoodUseCase;
  final DeleteFoodUseCase deleteFoodUseCase;
  final CalculateMealUseCase calculateMealUseCase;
  
  const MyApp({
    Key? key,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.checkAuthStateUseCase,
    required this.getUserRoleUseCase,
    required this.isAdminUseCase,
    required this.getUserEmailUseCase,
    required this.getUserInfoUseCase,
    required this.updateUserInfoUseCase,
    required this.changePasswordUseCase,
    required this.deleteAccountUseCase,
    required this.getAllFoodsUseCase,
    required this.getFoodUseCase,
    required this.createFoodUseCase,
    required this.updateFoodUseCase,
    required this.deleteFoodUseCase,
    required this.calculateMealUseCase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            logoutUseCase: logoutUseCase,
            checkAuthStateUseCase: checkAuthStateUseCase,
            getUserRoleUseCase: getUserRoleUseCase,
            isAdminUseCase: isAdminUseCase,
            getUserEmailUseCase: getUserEmailUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            getUserInfoUseCase: getUserInfoUseCase,
            updateUserInfoUseCase: updateUserInfoUseCase,
            changePasswordUseCase: changePasswordUseCase,
            deleteAccountUseCase: deleteAccountUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FoodProvider(
            getAllFoodsUseCase: getAllFoodsUseCase,
            getFoodUseCase: getFoodUseCase,
            createFoodUseCase: createFoodUseCase,
            updateFoodUseCase: updateFoodUseCase,
            deleteFoodUseCase: deleteFoodUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MealProvider(
            calculateMealUseCase: calculateMealUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Calory App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
