import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/app/extensions/dark_mode.dart';
import '/settings/app_settings.dart';

class Global {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static final GlobalKey<ScaffoldMessengerState> snackKey =
      GlobalKey<ScaffoldMessengerState>();
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static final AppSettings appSettings = AppSettings();
  static PageController pageCtrl = PageController();

  static bool isAnyDialogOpen(BuildContext context) {
    return ModalRoute.of(context)?.isCurrent != true;
  }

  static SystemUiOverlayStyle systemOverlayStyle(BuildContext context) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness:
          context.isDarkMode ? brightnessLight() : brightnessDark(),
      statusBarIconBrightness:
          context.isDarkMode ? brightnessLight() : brightnessDark(),
    );
  }

  static Brightness brightnessLight() {
    if (Platform.isAndroid) {
      return Brightness.light;
    } else {
      return Brightness.dark;
    }
  }

  static Brightness brightnessDark() {
    if (Platform.isAndroid) {
      return Brightness.dark;
    } else {
      return Brightness.light;
    }
  }
}
