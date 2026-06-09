import 'package:flutter/material.dart';

import '/services/system_chrome_service.dart';
import '/services/notification_service.dart';
import 'app/app.dart';
import 'app/errors/error_screen.dart';
import 'database/injector.dart';
import 'global/variables.dart';
import 'graphql/api/get_metadata.dart';
import 'firebase/firebase.dart';

Future<void> initlize() async {
  SystemChromeService.inject();

  await Database.inject();

  GetMetadata.request();
  await NotificationService.init();
  // Load the user's preferred theme while the splash screen is displayed.
  await Global.appSettings.loadSettings();

  ErrorWidget.builder = (FlutterErrorDetails err) => ErrorScreen('$err');

  FirebaseTool.getFirebaseToken().whenComplete(
    () => FirebaseTool.setFirebaseTopics(),
  );

  // App listens to the [appSettings] for changes, then passes it further
  // down to the widget tree.
  runApp(const AmanaSend());
}
