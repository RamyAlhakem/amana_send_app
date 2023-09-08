import 'dart:convert';

import 'package:flutter/material.dart';

abstract class SafetyModel {
  void fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson();

  @override
  String toString() {
    return toJson().toString();
  }

  static Color parseColor(String hexCode, {double? opacity}) {
    try {
      return Color(int.parse(hexCode.replaceAll('#', '0xFF')))
          .withOpacity(opacity ?? 1);
    } catch (e) {
      return const Color(0xFFCCCCCC).withOpacity(opacity ?? 1);
    }
  }

  Color colorFromJson(Map<String, dynamic>? json, String attribute,
      {String defaultHexColor = '#000000'}) {
    try {
      return parseColor(json != null
          ? json[attribute] != null && json[attribute] != ''
              ? json[attribute].toString()
              : defaultHexColor
          : defaultHexColor);
    } catch (e) {
      return Colors.transparent;
    }
  }

  String stringFromJson(Map<String, dynamic>? json, String attribute,
      {String defaultValue = ''}) {
    try {
      return json != null
          ? json[attribute] != null && json[attribute] != ''
              ? json[attribute].toString()
              : defaultValue
          : defaultValue;
    } catch (e) {
      return '';
    }
  }

  String dateFromJson(Map<String, dynamic>? json, String attribute,
      {String defaultValue = '', int length = 10}) {
    try {
      if (json != null) {
        if (json[attribute] != null && '${json[attribute]}'.isNotEmpty) {
          if (json[attribute] != '0000-00-00') {
            return json[attribute].toString().substring(0, length);
          }
        }
      }
      return defaultValue;
    } catch (e) {
      return '';
    }
  }

  dynamic mapFromJson(Map<String, dynamic>? json, String? attribute,
      {Map<dynamic, dynamic>? defaultValue}) {
    try {
      return json != null
          ? json[attribute] != null && json[attribute] != ''
              ? jsonDecode(json[attribute])
              : defaultValue
          : defaultValue!;
    } catch (e) {
      return {};
    }
  }

  int intFromJson(Map<String, dynamic>? json, String attribute,
      {int defaultValue = 0}) {
    try {
      if (json != null && json[attribute] != null && json[attribute] != '') {
        if (json[attribute] is int) {
          return json[attribute];
        }
        return int.parse(json[attribute].toString());
      }
      return defaultValue;
    } catch (e) {
      return 0;
    }
  }

  double doubleFromJson(Map<String, dynamic>? json, String? attribute,
      {int decimal = 2, double defaultValue = 0.0}) {
    try {
      if (json != null && json[attribute] != null && json[attribute] != '') {
        if (json[attribute] is double) {
          return double.parse(json[attribute].toStringAsFixed(decimal));
        }
        if (json[attribute] is int) {
          return double.parse(
              json[attribute].toDouble().toStringAsFixed(decimal));
        }
        return double.parse(
            double.tryParse(json[attribute])!.toStringAsFixed(decimal));
      }
      return double.parse(defaultValue.toStringAsFixed(decimal));
    } catch (e) {
      return 0;
    }
  }

  bool boolFromJson(Map<String, dynamic>? json, String? attribute,
      {bool defaultValue = false}) {
    try {
      if (json != null && json[attribute] != null && json[attribute] != '') {
        if (json[attribute] is bool) {
          return json[attribute];
        } else if ((json[attribute] is String) &&
            !['0', '', 'false'].contains(json[attribute])) {
          return true;
        } else if ((json[attribute] is int) &&
            ![0, -1].contains(json[attribute])) {
          return true;
        }
        return false;
      }
      return defaultValue;
    } catch (e) {
      return false;
    }
  }

  List<T> listFromJsonArray<T>(Map<String, dynamic> json,
      List<String>? attribute, T Function(Map<String, dynamic>) callback) {
    String? attributes =
        attribute!.firstWhere((element) => (json[element] != null));
    return listFromJson(json, attributes, callback);
  }

  List<T> listFromJson<T>(Map<String, dynamic>? json, String attribute,
      T Function(Map<String, dynamic>) callback) {
    try {
      List<T> list = <T>[];
      if (json != null &&
          json[attribute] != null &&
          json[attribute] != '' &&
          json[attribute] is List &&
          json[attribute].length > 0) {
        json[attribute].forEach((v) {
          if (v is Map<String, dynamic>) {
            list.add(callback(v));
          }
        });
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  List<String> listStringFromJson<T>(
      Map<String, dynamic>? json, String attribute) {
    try {
      List<String> list = <String>[];
      if (json != null &&
          json[attribute] != null &&
          json[attribute] != '' &&
          json[attribute] is List &&
          json[attribute].length > 0) {
        list = List<String>.from(json[attribute].map((x) => x));
      }
      return list;
    } catch (e) {
      return <String>[];
    }
  }

  List<int> listIntFromJson<T>(Map<String, dynamic>? json, String attribute) {
    try {
      List<int> list = <int>[];
      if (json != null &&
          json[attribute] != null &&
          json[attribute] != '' &&
          json[attribute] is List &&
          json[attribute].length > 0) {
        list = List<int>.from(json[attribute].map((x) => x));
      }
      return list;
    } catch (e) {
      return <int>[];
    }
  }

  T objectFromJson<T>(Map<String, dynamic>? json, String attribute,
      T Function(Map<String, dynamic>) callback,
      {required T defaultValue}) {
    try {
      if (json != null &&
          json[attribute] != null &&
          json[attribute] != '' &&
          json[attribute] is Map<String, dynamic>) {
        return callback(json[attribute]);
      }
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }
}
