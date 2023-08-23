import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '/database/injector.dart';
import '/firebase_options.dart';
import '/global/variables.dart';
import '/helper/helper.dart';
import '/models/firebase.dart';
import '../models/user_base.dart';

class FirebaseTool {
  static Future<void> getFirebaseToken() async {
    final UserBase user = Database().getUserBase;
    final FirebaseModel firebase = user.firebase;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      await firebaseMessaging.requestPermission();
      firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        sound: true,
      );

      firebase.token = (await firebaseMessaging.getToken() ?? '');
      user.firebase = firebase;
      Database().setUserBase = user;
    } catch (e) {
      Helper.log('firebase error: $e');
    }
    Helper.log('firebaseToken: ${firebase.token}');
  }

  static Future<void> setFirebaseTopics() async {
    final UserBase user = Database().getUserBase;
    final FirebaseModel firebase = user.firebase;

    if (!firebase.topics.contains('all')) {
      await FirebaseMessaging.instance.subscribeToTopic('all');
      firebase.topics.add('all');
    }

    if (Global.appSettings.token.isEmpty) {
      if (!firebase.topics.contains('visitors')) {
        await FirebaseMessaging.instance.subscribeToTopic('visitors');
        firebase.topics.add('visitors');
      }
      if (firebase.topics.contains('users')) {
        await FirebaseMessaging.instance.unsubscribeFromTopic('users');
        firebase.topics.remove('users');
      }
    } else {
      if (!firebase.topics.contains('users')) {
        await FirebaseMessaging.instance.subscribeToTopic('users');
        firebase.topics.add('users');
      }

      if (firebase.topics.contains('visitors')) {
        await FirebaseMessaging.instance.unsubscribeFromTopic('visitors');
        firebase.topics.remove('visitors');
      }
    }
    user.firebase = firebase;
    Database().setUserBase = user;

    Helper.log('firebaseTopics: ${firebase.topics}');

    notificationListener();
  }

  static void notificationListener() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) _handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(message);
    });
  }

  static void _handleMessage(RemoteMessage message) {}
}
