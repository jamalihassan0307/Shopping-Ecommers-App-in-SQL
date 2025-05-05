import 'package:get/get.dart';
import '../services/database_service.dart';
import '../services/shared_prefs_service.dart';

class AuthController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  final RxBool isLoggedIn = false.obs;
  final RxMap<String, dynamic> currentUser = RxMap<String, dynamic>();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final isUserLoggedIn = await SharedPrefsService.isLoggedIn();
    if (isUserLoggedIn) {
      final userId = await SharedPrefsService.getUserId();
      if (userId != null) {
        final user = await _databaseService.getUserById(userId);
        if (user != null) {
          currentUser.value = user;
          isLoggedIn.value = true;
        }
      }
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final user = await _databaseService.getUserByEmail(email);
      if (user != null && user['password'] == password) {
        currentUser.value = user;
        isLoggedIn.value = true;
        await SharedPrefsService.saveUserId(user['id']);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final existingUser = await _databaseService.getUserByEmail(email);
      if (existingUser != null) {
        return false; // User already exists
      }

      final userId = await _databaseService.createUser({
        'name': name,
        'email': email,
        'password': password,
      });

      if (userId > 0) {
        final user = await _databaseService.getUserById(userId);
        currentUser.value = user!;
        isLoggedIn.value = true;
        await SharedPrefsService.saveUserId(userId);
        return true;
      }
      return false;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    try {
      final result = await _databaseService.updateUser(userData);
      if (result > 0) {
        currentUser.value = userData;
        return true;
      }
      return false;
    } catch (e) {
      print('Profile update error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await SharedPrefsService.clearUserSession();
    currentUser.clear();
    isLoggedIn.value = false;
    Get.offAllNamed('/welcome');
  }

  bool get isAuthenticated => isLoggedIn.value;
  Map<String, dynamic> get user => currentUser;
} 