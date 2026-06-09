import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:amana_send/app_config.dart';

class Configs {
  // static const bool debug = true;

  static String appName = 'AmanaSend';
  static String packageName = 'com.amana_send';
  static String version = ''; // initialized in Metadata API request.
  static String buildNumber = ''; // initialized in Metadata API request.

  static  String baseUrl = AppConfig.baseUrl;
  static  String graphql = AppConfig.graphql;
  static  String apiRestPhoto = AppConfig.apiRestPhoto;
  static  String apiUrl = AppConfig.apiUrl;

  static String storeUrl = !kIsWeb && Platform.isIOS ? appleStore : googleStore;
  static String appleStore = 'https://apps.apple.com/app/id6474017595';
  static String googleStore =
      'https://play.google.com/store/apps/details?id=com.amana_send';
}
