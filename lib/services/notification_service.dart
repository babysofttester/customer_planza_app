import 'dart:developer';
import 'dart:typed_data';

import 'package:customer_app_planzaa/common/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// top-level background handler invoked by FCM when a message arrives while
// the app is terminated or in the background. It simply initializes Flutter
// and Firebase and forwards the message to the shared notification logic.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService._handleMessage(message);
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static late SharedPreferences _prefs;

  /// Initializes local notifications *and* Firebase cloud messaging.
  ///
  /// This method should be called once during app startup (for example in
  /// `main()` before `runApp`). It creates the required Android notification
  /// channels, registers the background message handler and sets up listeners
  /// for foreground/background messages so that chat/call notifications are
  /// shown regardless of app state.
  static Future<void> init() async {
    // initialize firebase first (if not done already). callers of this
    // method should also call `Firebase.initializeApp()` in main, but making
    // sure here keeps us safe during background handler invocations.
    try {
      await Firebase.initializeApp();
    } catch (_) {}
    _prefs = await SharedPreferences.getInstance();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings);

    // create channels for chat and calls
    const AndroidNotificationChannel chatChannel = AndroidNotificationChannel(
      'chat_channel',
      'Chat Messages',
      description: 'Channel for chat message notifications',
      importance: Importance.max,
    );

    const AndroidNotificationChannel callChannel = AndroidNotificationChannel(
      'call_channel',
      'Incoming Calls',
      description: 'Channel for incoming call notifications',
      importance: Importance.max,
    );

    final androidImpl = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(chatChannel);
    await androidImpl?.createNotificationChannel(callChannel);

    // request runtime permission for notifications (Android 13+ / iOS)
    try {
      await Permission.notification.request();
    } catch (_) {}

    // configure firebase messaging handlers
    await _configureFirebaseMessaging();
  }

  static Future<void> _configureFirebaseMessaging() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔹 Get initial token
    final token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      log('💡 Initial FCM token: $token');
      await _prefs.setString(Constants.fcmToken, token);
    }

    // 🔹 Listen for token refresh (ONLY ONCE)
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      log('💡 FCM token refreshed: $newToken');
      await _prefs.setString(Constants.fcmToken, newToken);
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleMessage);

    // When user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Background handler
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );
  }

  /// Common handler used by both foreground and background listeners. It
  /// dispatches specialized notifications depending on the `type` field in
  /// the incoming message's `data` payload.
  static Future<void> _handleMessage(RemoteMessage message) async {
    final data = message.data;
    final title = message.notification?.title ?? data['title'] ?? '';
    final body = message.notification?.body ?? data['body'] ?? '';

    if (data['type'] == 'call') {
      // show a high‑priority call notif with sound/vibration and full screen
      await showCallNotification(title: title, body: body);
    } else {
      await showNotification(title: title, body: body);
    }
  }

  /// Public wrapper so that external code (e.g. `main.dart`) can forward
  /// an incoming [RemoteMessage] that triggered the app launch.
  static Future<void> handleMessage(RemoteMessage message) async {
    await _handleMessage(message);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'chat_channel',
      'Chat Messages',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      title,
      body,
      details,
    );
  }

  /// Specialized notification used for incoming calls. Shows a high-priority
  /// alert with sound, vibration, and a full‑screen intent so that the user
  /// sees the call even if the screen is off.
  static Future<void> showCallNotification({
    required String title,
    required String body,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'call_channel',
      'Incoming Calls',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 2000]),
      fullScreenIntent: true,
    );

    final NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notifications.show(
      1,
      title,
      body,
      details,
    );
  }

  /// Convenience helper for other modules to remove the call notification.
  static Future<void> cancelCallNotification() async {
    await _notifications.cancel(1);
  }
}
