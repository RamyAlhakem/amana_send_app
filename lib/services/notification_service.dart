// 🎯 Dart imports:
import 'dart:developer';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 🌎 Project imports:
import 'package:amana_send/firebase_options.dart';

class NotificationService {
  const NotificationService._();

  static late final String? fcmToken;

  static late final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin;

  static late final AndroidNotificationChannel _channel;

  static late bool _isFlutterLocalNotificationsInitialized;

  //*.//////////////.*//
  //*.initialization.*//
  //*.//////////////.*//

  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey: kIsWeb ? kFirebaseWebVapidKey : null,
      );
      log(fcmToken ?? 'no FCM Token', name: 'FCM token');

      await _requestPermission();

      if (!kIsWeb) {
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');

        const DarwinInitializationSettings initializationSettingsDarwin =
            DarwinInitializationSettings();

        const InitializationSettings initializationSettings =
            InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

        _isFlutterLocalNotificationsInitialized = false;
        _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin()
          ..initialize(initializationSettings);

        await _setupFlutterNotifications();

        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler);
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
                alert: true, badge: true, sound: true);
      }

      _startListening();
    } catch (e) {
      if (kIsWeb && e.toString().contains('JavaScriptObject')) {
        log('Web Firebase error (JS interop): $e', name: 'NotificationService');
      } else if (e is FirebaseException) {
        log('Firebase error: ${e.message}', name: 'NotificationService');
      } else {
        log('NotificationService init error: $e', name: 'NotificationService');
      }
    }
  }

  static Future<void> periodicallyShowNotification({
    required DateTime dateTime,
    required int id,
    String? title,
    String? body,
    String? payload,
    String? customSound,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    if (kIsWeb) return;
    await _flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.daily,
      NotificationDetails(
        android: AndroidNotificationDetails(
          customSound ?? "channel2",
          "channel2",
          icon: "ic_launcher",
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          sound: customSound == null
              ? null
              : RawResourceAndroidNotificationSound(customSound),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      payload: payload,
    );
  }

  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    if (kIsWeb) return [];
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // static cancelNotification(int id) async {
  //   debugPrint('notification $id canceled');
  //   await _flutterLocalNotificationsPlugin.cancel(id);
  // }

  static cancelAllNotification() async {
    if (kIsWeb) return;
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  //*.///////////////.*//
  //*.private methods.*//
  //*.///////////////.*//
  static void _startListening() =>
      FirebaseMessaging.onMessage.listen(_showNotification);

  static Future<void> _requestPermission() async {
    if (kIsWeb) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      return;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    } else if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await _setupFlutterNotifications();
    _showNotification(message);
    log('Handling a background message: ${message.messageId}');
  }

  static Future<void> _setupFlutterNotifications() async {
    if (kIsWeb || _isFlutterLocalNotificationsInitialized) return;

    _channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  static void _showNotification(RemoteMessage message) {
    // On web, local notifications plugin is not initialized;
    // background messages are handled by the Firebase service worker.
    if (kIsWeb) {
      log(
        'Foreground message received: ${message.notification?.title}',
        name: 'NotificationService',
      );
      return;
    }

    Map notification = message.data;

    // Get title and body from notification or data
    final String? title = message.notification?.title ?? notification['title'];
    final String? body = message.notification?.body ?? notification['body'];

    _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          color: const Color(0xffFF634D),
          playSound: true,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentBanner: true,
          presentList: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
    );
  }
}
