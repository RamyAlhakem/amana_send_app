import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/services/system_chrome_service.dart';
import '/services/notification_service.dart';
import 'app/app.dart';
import 'database/injector.dart';
import 'global/variables.dart';
import 'graphql/api/get_metadata.dart';
import 'firebase/firebase.dart';

Future<void> initlize() async {
  // Web needs the binding initialized BEFORE we touch any plugin channel
  // (SharedPreferences / package_info_plus / GraphQL http link, etc.).
  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  SystemChromeService.inject();

  await Database.inject();

  // Load settings synchronously so the first frame is themed + auth-correct.
  await Global.appSettings.loadSettings();

  // Schedule non-essential work AFTER the first frame can render.
  // These touch the network and the device slow path — none of them should
  // delay the splash from disappearing.
  scheduleMicrotask(() {
    GetMetadata.request();
  });
  Future.microtask(() => NotificationService.init());
  Future.microtask(() {
    FirebaseTool.getFirebaseToken().whenComplete(
      () => FirebaseTool.setFirebaseTopics(),
    );
  });

  ErrorWidget.builder = (FlutterErrorDetails err) {
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            err.exceptionAsString(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  };

  // App listens to the [appSettings] for changes, then passes it further
  // down to the widget tree.
  runApp(const AmanaSend());
}
