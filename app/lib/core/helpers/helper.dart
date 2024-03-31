import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveString(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', value);
  }

  static Future<String?> getString() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  static Future<void> setLocation(String latlong) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentlocation', latlong);
  }

  static Future<String?> getLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentlocation');
  }
}
