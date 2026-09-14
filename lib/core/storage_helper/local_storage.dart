import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String isFirstTimeKey = "isFirstTime";

  static Future<void> setFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isFirstTimeKey, value);
  }

  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isFirstTimeKey) ?? true;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userKeys = prefs.getKeys().where((key) => key != isFirstTimeKey);
    for (final key in userKeys) {
      await prefs.remove(key);
    }
  }
}
