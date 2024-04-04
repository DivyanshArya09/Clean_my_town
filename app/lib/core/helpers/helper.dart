import 'dart:convert';

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

  static Future<void> setDestrict(String district) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentlocation', district);
  }

  static Future<void> setLocation(Map<String, dynamic> location) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(location);
    await prefs.setString('currentlocation', json);
    // return prefs
  }

  static Future<Map<String, dynamic>> getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonMap = await prefs.getString('currentlocation');
    if (jsonMap != null) {
      return jsonDecode(jsonMap);
    } else {
      return {};
    }
  }

  static Future<void> setCordinates(double lat, double lng) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('currentLatitude', lat);
    await prefs.setDouble('currentLongitude', lng);
  }

  static Future<List<double>> getCordinates() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double lat = prefs.getDouble('currentLatitude') ?? 0.0;
    final double lng = prefs.getDouble('currentLongitude') ?? 0.0;
    return [lat, lng];
  }

  // static Future<String?> getLocation() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('currentlocation');
  // }
}