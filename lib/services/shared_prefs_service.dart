import 'package:shared_preferences.dart';

class SharedPrefsService {
  static const String _userIdKey = 'user_id';
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.setBool(_isLoggedInKey, false);
  }
} 