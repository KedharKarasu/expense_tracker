import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtils {
  static SharedPreferences? _instance;
  
  static Future<SharedPreferences> getInstance() async {
    try {
      _instance ??= await SharedPreferences.getInstance();
      return _instance!;
    } catch (e) {
      print('SharedPreferences error: $e');
      // Fallback: create a mock instance or retry
      await Future.delayed(const Duration(milliseconds: 500));
      return SharedPreferences.getInstance();
    }
  }
  
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    try {
      final prefs = await getInstance();
      return prefs.getBool(key) ?? defaultValue;
    } catch (e) {
      print('Error reading bool preference: $e');
      return defaultValue;
    }
  }
  
  static Future<bool> setBool(String key, bool value) async {
    try {
      final prefs = await getInstance();
      return await prefs.setBool(key, value);
    } catch (e) {
      print('Error setting bool preference: $e');
      return false;
    }
  }
  
  static Future<String> getString(String key, {String defaultValue = ''}) async {
    try {
      final prefs = await getInstance();
      return prefs.getString(key) ?? defaultValue;
    } catch (e) {
      print('Error reading string preference: $e');
      return defaultValue;
    }
  }
  
  static Future<bool> setString(String key, String value) async {
    try {
      final prefs = await getInstance();
      return await prefs.setString(key, value);
    } catch (e) {
      print('Error setting string preference: $e');
      return false;
    }
  }
}
