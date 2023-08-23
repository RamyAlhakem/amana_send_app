import 'dart:io';

class Configs {
  static const bool debug = true;
  static const double apiVersion = 1.1;

  static String appName = 'AmanaSend';
  static String packageName = 'com.amana_send';
  static String version = ''; // initialized in Metadata API request.
  static String buildNumber = ''; // initialized in Metadata API request.

  static const String stagingUrl = 'https://amanaSend-staging.pages.dev/';
  static const String productionUrl = 'https://amanaSend.pages.dev/';

  static const String graphqlStaging =
      'https://staging-api-ca.iii0.com/graphql';
  static const String graphqlProduction = 'https://api-ca.iii0.com/graphql';

  static const String apiStaging = 'https://staging-api-ca.iii0.com/';
  static const String apiProduction = 'https://api-ca.iii0.com/';

  static const String photoStaging = 'https://staging-api-ca.iii0.com/photo';
  static const String photoProduction = 'https://api-ca.iii0.com/photo';

  static const String baseUrl = debug ? stagingUrl : productionUrl;
  static const String graphql = debug ? graphqlStaging : graphqlProduction;
  static const String apiRestPhoto = debug ? photoStaging : photoProduction;
  static const String apiUrl = debug ? apiStaging : apiProduction;

  static String storeUrl = Platform.isIOS ? appleStore : googleStore;
  static const String appleStore = 'https://apps.apple.com/app/id64433';
  static const String googleStore =
      'https://play.google.com/store/apps/details?id=com.amana_send';
}
