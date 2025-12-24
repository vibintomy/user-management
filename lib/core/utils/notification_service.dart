import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final Logger _logger = Logger();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

 Future<void> initialize() async {
  // Request permission
  NotificationSettings settings = await _fcm.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    _logger.i('User granted notification permission');
  }

  // Get FCM token SAFELY
  try {
    _fcmToken = await _fcm.getToken();
    _logger.i('FCM Token: $_fcmToken');
    if (_fcmToken == null) {
      _logger.w('FCM Token is null – likely running on emulator without Google Play Services');
    }
  } catch (e) {
    _logger.e('Failed to get FCM token: $e');
    // Optional: Retry later or skip on emulator
    _fcmToken = null;
  }

  // Listen to token refresh (safe even if initial token failed)
  _fcm.onTokenRefresh.listen((token) {
    _fcmToken = token;
    _logger.i('FCM Token refreshed: $token');
  });

  // Rest of your code (local notifications, handlers) remains the same
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await _localNotifications.initialize(
    initSettings,
    onDidReceiveNotificationResponse: _onNotificationTapped,
  );

  FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
}

  void _handleForegroundMessage(RemoteMessage message) {
    _logger.i('Foreground message received: ${message.notification?.title}');
    _showLocalNotification(message);
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    _logger.i('Background message opened: ${message.notification?.title}');
    // Handle navigation based on notification data
  }

  void _onNotificationTapped(NotificationResponse response) {
    _logger.i('Notification tapped: ${response.payload}');
    // Handle navigation
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: message.data.toString(),
    );
  }
}