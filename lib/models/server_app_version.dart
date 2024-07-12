import 'dart:io';

import '/configs/configs.dart';
import '/helper/safety_model.dart';
import '/router/app_route.dart';
import '/tools/tools.dart';

class ServerAppVersion extends SafetyModel {
  ServerAppVersion({this.apple = '1.0', this.android = '1.0'});

  String apple = '1.0', android = '1.0';

  static ServerAppVersion get = ServerAppVersion();
  String api = '1.0';

  ServerAppVersion.fromJson(Map<String, dynamic> json) {
    apple = stringFromJson(json, 'apiAppleVersion', defaultValue: '1.0');
    android = stringFromJson(json, 'apiAndroidVersion', defaultValue: '1.0');
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
        'apiAppleVersion': apple,
        'apiAndroidVersion': android,
      };

  ServerAppVersion.isUpdate() {
    if (Platform.isIOS) {
      api = ServerAppVersion.get.apple;
    } else {
      api = ServerAppVersion.get.android;
    }

    final bool update = Tools.compareVersion(Configs.version, api) == -1;
    if (update) {
       AppRoute.get().then((router) => router.push('/${AppRoute.updateApp}'));
      //AppRoute.routes.goNamed('/${AppRoute.updateApp}');
    }
  }
}
