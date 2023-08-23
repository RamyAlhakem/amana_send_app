import 'dart:io';

import '/configs/configs.dart';
import '/helper/helper.dart';
import '/helper/safety_model.dart';
import '/router/app_route.dart';

class ServerAppVersion extends SafetyModel {
  ServerAppVersion({this.apple = 1.0, this.android = 1.0});

  double apple = 1.0;
  double android = 1.0;

  static double appVersion = 1.0;

  ServerAppVersion.fromJson(Map<String, dynamic> json) {
    apple = doubleFromJson(json, 'apiAppleVersion', defaultValue: 1.0);
    android = doubleFromJson(json, 'apiAndroidVersion', defaultValue: 1.0);
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
        'apiAppleVersion': apple,
        'apiAndroidVersion': android,
      };

  ServerAppVersion.isUpdate() {
    if (Platform.isIOS) {
      appVersion = Helper.serverAppVersion.apple;
    } else {
      appVersion = Helper.serverAppVersion.android;
    }

    if (appVersion > Configs.apiVersion) {
      AppRoute.get().then((router) => router.go('/${AppRoute.updateApp}'));
    }
  }
}
