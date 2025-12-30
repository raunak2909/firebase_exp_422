import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    await _requestPermission();
    await _setupMessageHandlers();
    final token = await _messaging.getToken();
    //FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    print('FCM Token: $token');
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    print('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      handleBackgroundMessage(initialMessage);
    }
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (message.data['type'] == 'chat') {
      // open chat screen
    }
    print("msg: ${message.data}");
  }

  /*Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;
    _isFlutterLocalNotificationsInitialized = true;
  }*/

  Future<void> showNotification(RemoteMessage message) async {
    print('foreground message received: ${message.messageId}');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            "Test",
            "Checking",
            channelDescription: "Notification testing from FCM",
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  }
}