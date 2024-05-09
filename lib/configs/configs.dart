import 'dart:io';

class Configs {
  static const bool debug = true;

  static String appName = 'AmanaSend';
  static String packageName = 'com.amana_send';
  static String version = ''; // initialized in Metadata API request.
  static String buildNumber = ''; // initialized in Metadata API request.

  static const String stagingUrl = 'https://amanasend.com/';
  static const String productionUrl = 'https://amanasend.com/';

  static const String graphqlStaging =
      'https://api.amanasend.com/staging/graphql';
  static const String graphqlProduction = 'https://api.amanasend.com/graphql';

  static const String apiStaging = 'https://api.amanasend.com/staging/';
  static const String apiProduction = 'https://api.amanasend.com/';

  static const String photoStaging = 'https://api.amanasend.com/staging/photo';
  static const String photoProduction = 'https://api.amanasend.com/photo';

  static const String baseUrl = debug ? stagingUrl : productionUrl;
  static const String graphql = debug ? graphqlStaging : graphqlProduction;
  static const String apiRestPhoto = debug ? photoStaging : photoProduction;
  static const String apiUrl = debug ? apiStaging : apiProduction;

  static String storeUrl = Platform.isIOS ? appleStore : googleStore;
  static String appleStore = 'https://apps.apple.com/app/id6474017595';
  static String googleStore =
      'https://play.google.com/store/apps/details?id=com.amana_send';
}
