import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '/models/user.dart';
import '/models/user_base.dart';

class Database {
  static SharedPreferences? _preferences;
  static String userKey = 'user_key';
  static String userBaseKey = 'user_base_key';

  static Future<void> inject() async {
    _preferences = await SharedPreferences.getInstance();
  }

  set setUser(UserModel user) {
    _preferences?.setString(userKey, json.encode(user.toJson()));
  }

  UserModel get getUser {
    String userJson = _preferences?.getString(userKey) ?? '';
    if (userJson.isEmpty) return UserModel();
    return UserModel.fromJson(json.decode(userJson));
  }

  static Future<void> clearUser() async => await _preferences?.remove(userKey);

  //
  //
  //
  // User local data app preferences:
  set setUserBase(UserBase user) {
    _preferences?.setString(userBaseKey, json.encode(user.toJson()));
  }

  UserBase get getUserBase {
    String userJson = _preferences?.getString(userBaseKey) ?? '';
    if (userJson.isEmpty) return UserBase();
    return UserBase.fromJson(json.decode(userJson));
  }
  //
}
