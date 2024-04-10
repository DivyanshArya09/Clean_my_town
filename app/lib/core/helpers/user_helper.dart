import 'dart:convert';

import 'package:app/core/errors/failures.dart';
import 'package:app/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveUser(String value) async {
    final prefs = await sl<SharedPreferences>();
    await prefs.setString('uid', value);
  }

  static Future<String?> getUser() async {
    final prefs = await sl<SharedPreferences>();
    return prefs.getString('uid');
  }

  // static Future<void> setDestrict(String district) async {
  //   final prefs = await sl<SharedPreferences>();
  //   await prefs.setString('currentlocation', district);
  // }

  static Future<void> setLocation(Map<String, dynamic> location) async {
    final prefs = await sl<SharedPreferences>();
    String json = jsonEncode(location);
    await prefs.setString('currentlocation', json);
  }

  static Future<Either<Failure, Map<String, dynamic>>> getLocation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jsonMap = await prefs.getString('currentlocation');
      if (jsonMap != null) {
        return Right(jsonDecode(jsonMap));
      } else {
        return Left(CacheFailure(message: 'No location found'));
      }
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  static Future<void> logOut() async {
    final prefs = await sl<SharedPreferences>();
    // await prefs.remove('currentlocation');
    await prefs.remove('uid');
  }

  // static Future<void> setCordinates(double lat, double lng) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setDouble('currentLatitude', lat);
  //   await prefs.setDouble('currentLongitude', lng);
  // }

  // static Future<List<double>> getCordinates() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final double lat = prefs.getDouble('currentLatitude') ?? 0.0;
  //   final double lng = prefs.getDouble('currentLongitude') ?? 0.0;
  //   return [lat, lng];
  // }

  // static Future<String?> getLocation() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('currentlocation');
  // }
}