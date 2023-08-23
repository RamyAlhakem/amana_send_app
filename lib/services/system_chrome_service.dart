import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemChromeService {
  static void inject() {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarBrightness: Brightness.dark,
    //     statusBarIconBrightness: Brightness.dark,
    //     // systemNavigationBarIconBrightness: Brightness.dark,
    //   ),
    // );
  }
}
