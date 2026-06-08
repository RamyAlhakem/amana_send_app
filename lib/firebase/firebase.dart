import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '/database/injector.dart';
import '/global/variables.dart';
import '/helper/helper.dart';
import '/models/firebase.dart';
import '/models/transfer.dart';
import '/models/user_base.dart';
import '/router/app_route.dart';

class FirebaseTool {
  static Future<void> getFirebaseToken() async {
    final UserBase user = Database().getUserBase;
    final FirebaseModel firebase = user.firebase;

    try {
      // Firebase is already initialized by NotificationService
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      
      firebase.token = (await firebaseMessaging.getToken() ?? '');
      user.firebase = firebase;
      Database().setUserBase = user;
    } catch (e) {
      if (kIsWeb && e.toString().contains('JavaScriptObject')) {
        Helper.log('firebase web error (JS interop): $e');
      } else if (e is FirebaseException) {
        Helper.log('firebase error: ${e.message}');
      } else {
        Helper.log('firebase error: $e');
      }
    }
    Helper.log('firebaseToken: ${firebase.token}');
  }

  static Future<void> setFirebaseTopics() async {
    try {
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

      _notificationListener();
    } catch (e) {
      if (kIsWeb && e.toString().contains('JavaScriptObject')) {
        Helper.log('firebase topics web error (JS interop): $e');
      } else if (e is FirebaseException) {
        Helper.log('firebase topics error: ${e.message}');
      } else {
        Helper.log('firebase topics error: $e');
      }
    }
  }

  static void _notificationListener() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) _backgroundMessage(message);
    });

    // FirebaseMessaging.onBackgroundMessage(_backgroundMessage);
    FirebaseMessaging.onMessage.listen((m) => _backgroundMessage(m));
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _backgroundMessage(m));
  }

  static Future<void> _backgroundMessage(RemoteMessage message) async {
    final String route = message.data['route']?.toString() ?? '';
    final String routeName = route.split('/').first;
    int id = 0;

    Helper.log('route name: $route');
    Helper.log('message body: ${message.notification?.body}');

    try {
      final List<String> routeParts = route.split('/');
      if (routeParts.length > 1) {
        final String routeId = routeParts[1];
        id = int.parse(routeId);
      }
    } catch (e) {
      Helper.log('_backgroundMessage error: routeId $e');
    }

    AppRoute.get().then((router) {
      switch (routeName.toLowerCase()) {
        case 'transfer':
          final TransferModel transfer = TransferModel(id: id);
          return router.goNamed(
            '/${AppRoute.transfer}',
            pathParameters: <String, String>{'transfer': jsonEncode(transfer)},
          );
      }
    });
  }
}
