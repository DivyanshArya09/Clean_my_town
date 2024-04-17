import 'dart:convert';

import 'package:app/core/errors/failures.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:app/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveUid(String value) async {
    final prefs = await sl<SharedPreferences>();
    await prefs.setString('uid', value);
  }

  static Future<void> setFCMtoken(String token) async {
    final prefs = await sl<SharedPreferences>();
    await prefs.setString('token', token);
  }

  static Future<String?> getFCMtoken() async {
    final prefs = await sl<SharedPreferences>();
    return prefs.getString('token');
  }

  static Future<String?> getUser() async {
    final prefs = await sl<SharedPreferences>();
    return prefs.getString('uid');
  }

  static Future<void> SaveUser(Map<String, dynamic> user) async {
    final prefs = await sl<SharedPreferences>();
    String json = jsonEncode(user);
    await prefs.setString('currentuser', json);
  }

  static Future<UserModel?> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jsonMap = await prefs.getString('currentuser');
      if (jsonMap != null) {
        return UserModel.fromMap(jsonDecode(jsonMap));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

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
    await prefs.remove('uid');
    await prefs.remove('currentuser');
  }
}
