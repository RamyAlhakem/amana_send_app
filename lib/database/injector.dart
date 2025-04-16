import 'dart:convert';

import 'package:amana_send/models/payment_method.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/models/user.dart';
import '/models/user_base.dart';

class Database {
  static SharedPreferences? _preferences;
  static String userKey = 'user_key';
  static String userBaseKey = 'user_base_key';
  static String paymentKey = 'payment_key';

  static Future<void> inject() async {
    _preferences = await SharedPreferences.getInstance();
  }

  set setUser(UserModel user) {
    _preferences?.setString(userKey, json.encode(user.toJson()));
  }

  set setCurrency(PaymentMethodModel payment) {
    _preferences?.setString(paymentKey, json.encode(payment.toJson()));
  }

  PaymentMethodModel get getPaymentMethod {
    String paymentJson = _preferences?.getString(paymentKey) ?? '';
    if (paymentJson.isEmpty) return PaymentMethodModel();
    return PaymentMethodModel.fromJson(json.decode(paymentJson));
  }

  UserModel get getUser {
    String userJson = _preferences?.getString(userKey) ?? '';
    if (userJson.isEmpty) return UserModel();
    return UserModel.fromJson(json.decode(userJson));
  }

  static Future<void> clearUser() async => await _preferences?.remove(userKey);

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
