import 'package:amana_send/flavor.dart';


class AppConfig {
  static String get baseUrl {
    switch (F.appFlavor) {
      case Flavor.production:
        return 'https://amanasend.com/';
      case Flavor.staging:
        return 'https://amanasend.com/';
      default:
        return 'https://amanasend.com/';
    }
  }

  static String get graphql {
    switch (F.appFlavor) {
      case Flavor.production:
        return 'https://api.amanasend.com/graphql';
      case Flavor.staging:
        return 'https://api.amanasend.com/staging/graphql';
      default:
        return 'https://api.amanasend.com/staging/graphql';
    }
  }

  static String get apiRestPhoto {
    switch (F.appFlavor) {
      case Flavor.production:
        return 'https://api.amanasend.com/photo';
      case Flavor.staging:
        return 'https://api.amanasend.com/staging/photo';
      default:
        return 'https://api.amanasend.com/staging/photo';
    }
  }
  static String get apiUrl{
    switch(F.appFlavor){
      case Flavor.production:
      return 'https://api.amanasend.com/';
      case Flavor.staging:
      return 'https://api.amanasend.com/staging/';
      default:
      return 'https://api.amanasend.com/staging/';
    }
  }
}


