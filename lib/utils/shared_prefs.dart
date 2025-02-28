import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("firstTime") ?? true;
  }

  static Future<void> setFirstTime(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("firstTime", value);
  }

  static Future<void> setRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("role", role);
  }

  static Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }
}
