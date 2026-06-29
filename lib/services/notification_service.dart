import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:cbfapp/models/device_token_model.dart';
import 'package:cbfapp/util/constants.dart';
import 'baseUrl.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // Initialize FCM and set up handlers
  static Future<void> init() async {
    // Request notification permissions (iOS only, Android 13+)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    // Get FCM token for this device
    String? token = await _firebaseMessaging.getToken();
    log('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground message received: ${message.notification?.title}');
      _handleForegroundMessage(message);
    });

    // Handle notification when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Message opened app: ${message.notification?.title}');
      _handleNotificationClick(message);
    });

    // Handle initial message when app is launched from notification
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      log('App launched from notification: ${initialMessage.notification?.title}');
      _handleNotificationClick(initialMessage);
    }
  }

  // Handle foreground notification display
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    final apple = message.notification?.apple;

    if (notification != null) {
      log('Title: ${notification.title}, Body: ${notification.body}');

      // You can show a dialog, snackbar, or custom notification here
      // Example: Show a snackbar (requires BuildContext, implement based on your app)
    }

    // Handle Android-specific notification
    if (android != null) {
      log('Android notification: ${android.priority}');
    }

    // Handle iOS-specific notification
    if (apple != null) {
      log('iOS notification: ${apple.sound}');
    }
  }

  // Handle notification click
  static Future<void> _handleNotificationClick(RemoteMessage message) async {
    log('Notification clicked: ${message.notification?.title}');
    // Navigate to specific screen based on notification data
    // Example:
    // final data = message.data;
    // Get.toNamed('/details', arguments: data);
  }

  // Subscribe to topic (optional)
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    log('Subscribed to topic: $topic');
  }

  // Unsubscribe from topic (optional)
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    log('Unsubscribed from topic: $topic');
  }

  // Get FCM token
  static Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Delete FCM token (on logout)
  static Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    log('FCM token deleted');
  }

  // Register device token with backend API
  static Future<DeviceTokenResponse> registerDeviceToken({
    required int userId,
    required String deviceToken,
    required String deviceName,
    required String platform,
  }) async {
    try {
      final registerDeviceTokenUrl =
          '$baseUrl${apiRoutes['REGISTER_DEVICE_TOKEN']}';

      final response = await http.post(
        Uri.parse(registerDeviceTokenUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': userId,
          'deviceToken': deviceToken,
          'deviceName': deviceName,
          'platform': platform,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        log('Device token registered successfully');
        return DeviceTokenResponse.fromJson(data);
      } else {
        log('Failed to register device token: ${response.statusCode}');
        throw Exception(
            'Failed to register device token: ${response.statusCode}');
      }
    } catch (e) {
      log('Error registering device token: $e');
      throw Exception('Error registering device token: $e');
    }
  }
}
