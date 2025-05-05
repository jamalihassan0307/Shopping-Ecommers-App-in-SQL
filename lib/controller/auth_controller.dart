import 'package:get/get.dart';
import '../services/database_service.dart';

class AuthController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  final RxBool isLoggedIn = false.obs;
  final RxMap<String, dynamic> currentUser = RxMap<String, dynamic>();

  Future<bool> login(String email, String password) async {
    try {
      final user = await _databaseService.getUserByEmail(email);
      if (user != null && user['password'] == password) {
        currentUser.value = user;
        isLoggedIn.value = true;
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
        final user = await _databaseService.getUserByEmail(email);
        currentUser.value = user!;
        isLoggedIn.value = true;
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

  void logout() {
    currentUser.clear();
    isLoggedIn.value = false;
  }

  bool get isAuthenticated => isLoggedIn.value;
  Map<String, dynamic> get user => currentUser;
} 