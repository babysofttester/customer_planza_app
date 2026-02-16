/* import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'common/constants.dart';
import 'common/translation_singleton.dart';
import 'common/utils.dart';
import 'pages/splash_screen.dart';


late SharedPreferences sharedPreferences;
final FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();
const String NOTIFICATION_CHANNEL_ID = 'high_importance_channel_v2';

// const String NOTIFICATION_CHANNEL_ID = 'high_importance_channel';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  
  await Firebase.initializeApp();

}

void handleNotificationNavigation(Map<String, dynamic> data) {
  print('═' * 80);
  print('🔀 HANDLING NOTIFICATION NAVIGATION');
  print('═' * 80);
  print('Timestamp: ${DateTime.now()}');
  print('Data received:');
  data.forEach((key, value) {
    print('   $key: $value');
  });
  print('');

  if (!data.containsKey('event_type')) {
    print('❌ No event_type found in data - NAVIGATION CANCELLED');
    print('═' * 80);
    return;
  }

  final eventType = data['event_type'];
  print('Event Type: $eventType');
  print('');

  if (eventType == 'reminder_notification') {
    print('→ Navigating to: Still Working');
    Constants.appbarHeading.value = 'Still Working';
    // Get.offAll(() => StartEndDay(name: 'Still Working'));
  } else if (eventType == 'whatsapp') {
    print('→ Navigating to: WhatsApp Manager');
    // Get.offAll(() => WhatsappManagerPage(
    //       accessCode: data['access_code'] ?? '',
    //       contactName: data['contact_name'] ?? '',
    //       guestPhoneNo: data['guest_phone_no'] ?? '',
    //       guestName: data['guest_name'] ?? '',
    //       countryCode: data['country_code'] ?? '',
    //        bookingId: data['booking_id'] ?? '',
    //       templateList: [],
    //     ));
  } else if (eventType == 'clock_in') {
    print('→ Navigating to: Start/End Day');
    // Get.offAll(() => StartEndDay(name: Constants.appbarHeading.value));
  } else if (eventType == 'discount_request') {
    print('→ Navigating to: Approve Discount');
    // Get.offAll(() => ApproveDiscountPage(
    //       reason: data['reason'],
    //       amount: data['amount'],
    //       approved_by: data['approved_by'],
    //       discount_type: data['discount_type'],
    //       bookingId: data['booking_id'],
    //       userType: "Concierge",
    //       userName: data['concierge_name'],
    //       propertyName: data['villa_name'],
    //     ));
  } else if (eventType == 'notice_board_notification') {
    print('→ Navigating to: Tasks Page');
    // Get.offAll(() => const TasksPage());
  } else {
    print('❌ Unknown event_type: $eventType - NO NAVIGATION');
  }

  print('✅ Navigation complete');
  print('═' * 80);
}

Future<void> showLocalNotification(
  FlutterLocalNotificationsPlugin plugin,
  int id,
  String title,
  String body,
  String payload,
) async {
  const androidDetails = AndroidNotificationDetails(
    NOTIFICATION_CHANNEL_ID,
    'High Importance Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const details = NotificationDetails(android: androidDetails);

  await plugin.show(id, title, body, details, payload: payload);
}

@pragma('vm:entry-point')
Future<void> main() async {
  print('═' * 80);
  print('🚀 APP LAUNCHING');
  print('═' * 80);
  print('Timestamp: ${DateTime.now()}');
  print('');

  WidgetsFlutterBinding.ensureInitialized();
  print('✅ Widgets binding initialized');

  print('Initializing Firebase...');
  await Firebase.initializeApp();
  print('✅ Firebase initialized');
  print('');

  print('Registering background message handler...');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  print('✅ Background message handler registered');
  print('');

  print('═' * 80);
  print('🔥 SETTING UP FCM LISTENERS (GLOBAL - BEFORE APP STARTS)');
  print('═' * 80);
  print('');

  // Initialize local notifications FIRST (needed for onMessage)
  print('Initializing local notifications plugin...');
  try {
    const androidInit =
        AndroidInitializationSettings('@drawable/launcher_icon');
    const iosInit = DarwinInitializationSettings(
      requestBadgePermission: true,
      requestAlertPermission: true,
      requestSoundPermission: true,
    );
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);
    await fln.initialize(initSettings);
    print('✅ Local notifications plugin initialized');

    // Create notification channel IMMEDIATELY
    print('Creating notification channel...');
    print('Creating notification channel WITH CUSTOM SOUND...');
    await fln
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            NOTIFICATION_CHANNEL_ID,
            'High Importance Notifications',
            description: 'Used for important notifications',
            importance: Importance.max,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('custom_sound'),
          ),
        );
    print(
        '✅ Notification channel created with custom sound: $NOTIFICATION_CHANNEL_ID');
    print('');
    print('✅ Notification channel created: $NOTIFICATION_CHANNEL_ID');
    print('');
  } catch (e) {
    print('❌ Error initializing local notifications: $e');
    print('Stack trace: ${StackTrace.current}');
    print('');
  }

  // Setup FCM listeners globally
  print('Setting up FCM listeners globally...');

  // 1. Foreground listener
  print('1️⃣ Setting up onMessage listener...');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('═' * 80);
    print('🟢 FOREGROUND MESSAGE RECEIVED (GLOBAL LISTENER)');
    print('═' * 80);
    print('Timestamp: ${DateTime.now()}');
    print('Message ID: ${message.messageId}');
    print('From: ${message.from}');
    print('');

    if (message.notification != null) {
      print('📢 NOTIFICATION OBJECT:');
      print('   Title: ${message.notification!.title}');
      print('   Body: ${message.notification!.body}');
      print('   Android Channel: ${message.notification!.android?.channelId}');
      print('');
    }

    print('📦 DATA PAYLOAD:');
    if (message.data.isNotEmpty) {
      message.data.forEach((key, value) {
        print('   $key: $value');
      });
      print('');
    } else {
      print('   ⚠️  Data payload is EMPTY');
      print('');
    }

    final data = message.data;
    final title = data['title'] ?? message.notification?.title ?? 'New message';
    final body = data['message'] ?? message.notification?.body ?? '';

    print('📱 DISPLAYING FOREGROUND NOTIFICATION:');
    print('   Title: $title');
    print('   Body: $body');
    print('   Channel: $NOTIFICATION_CHANNEL_ID');
    print('');

    if (body.isNotEmpty) {
      final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      try {
        fln.show(
          notificationId,
          title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              NOTIFICATION_CHANNEL_ID,
              'High Importance Notifications',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              enableVibration: true,
                // sound: RawResourceAndroidNotificationSound('custom_sound'),
              ticker: 'ticker',
            ),
          ),
          payload: jsonEncode(data),
        );
        print('✅ Foreground notification displayed with ID: $notificationId');
      } catch (e) {
        print('❌ Error displaying foreground notification: $e');
        print('Stack trace: ${StackTrace.current}');
      }
    } else {
      print('❌ Body is empty - notification NOT displayed');
    }
    print('═' * 80);
  });
  print('✅ onMessage listener registered');
  print('');

  // 2. Background/Killed tap listener
  print('2️⃣ Setting up onMessageOpenedApp listener...');
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('═' * 80);
    print('🟡 NOTIFICATION TAPPED FROM BACKGROUND/KILLED (GLOBAL LISTENER)');
    print('═' * 80);
    print('Timestamp: ${DateTime.now()}');
    print('Data: ${message.data}');
    print('');
    Future.delayed(const Duration(milliseconds: 1000), () {
      print('Navigating after 500ms delay... 3');
      handleNotificationNavigation(message.data);
    });
    print('═' * 80);
  });
  print('✅ onMessageOpenedApp listener registered');
  print('');

  // 3. Check initial message (killed state)
  print('3️⃣ Checking for initial message (killed state)...');
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print('═' * 80);
    print('🟠 APP OPENED FROM KILLED STATE VIA NOTIFICATION (GLOBAL)');
    print('═' * 80);
    print('Timestamp: ${DateTime.now()}');
    print('Data: ${initialMessage.data}');
    print('');
    Future.delayed(const Duration(milliseconds: 1000), () {
      print('Navigating after 500ms delay...');
      handleNotificationNavigation(initialMessage.data);
    });
    print('═' * 80);
  } else {
    print('   No initial message (normal app launch)');
  }
  print('');

  // 4. Request permissions and get token
  print('4️⃣ Requesting permissions and getting token...');
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );
  print('   AuthorizationStatus: ${settings.authorizationStatus}');
  print('✅ Permissions requested');
  print('');

  // 5. Set foreground options
  print('5️⃣ Setting foreground presentation options...');
  // Suppress default system notification for terminated/foreground state
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: false,
    sound: false,
  );
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  print('✅ Foreground options set');
  print('');

  // 6. Get and store token
  print('6️⃣ Retrieving FCM token...');
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    print('   Token obtained: $token');
  } else {
    print('   ❌ Failed to get token');
  }
  print('');

  print('═' * 80);
  print('✅ ALL FCM LISTENERS REGISTERED GLOBALLY');
  print('═' * 80);
  print('');

  // TEST: Show a test notification to verify system is working
  print('⏳ VERIFICATION TEST: Displaying test notification...');
  await Future.delayed(const Duration(seconds: 2));
  try {
   
    print('✅ TEST NOTIFICATION DISPLAYED - notification system is working!');
  } catch (e) {
    print('❌ TEST NOTIFICATION FAILED: $e');
    print('   This means the local notification system has an issue');
  }
  print('');

  print('Initializing timezone...');
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
  print('✅ Timezone initialized to Asia/Kolkata');
  print('');

  HttpOverrides.global = MyHttpOverrides();
  print('✅ HTTP overrides configured');

  print('Loading translations...');
  await TranslationService().loadTranslations();
  print('✅ Translations loaded');
  print('');

  print('Starting Flutter app...');
  await fln
  .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(
    const AndroidNotificationChannel(
      NOTIFICATION_CHANNEL_ID,
      // 'high_importance_channel_v3',
      'High Importance Notifications',
      description: 'Used for important notifications',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('custom_sound'),
    ),
  );

  runApp(
    ShowCaseWidget(
      builder: (context) => const ClubMiracleApp(),
    ),
  );
}

class ClubMiracleApp extends StatefulWidget {
  const ClubMiracleApp({super.key});

  @override
  State<ClubMiracleApp> createState() => _ClubMiracleAppState();
}

class _ClubMiracleAppState extends State<ClubMiracleApp> {
  late FlutterLocalNotificationsPlugin notifications;
  AppUpdateInfo? _updateInfo;

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    NOTIFICATION_CHANNEL_ID,
    'High Importance Notifications',
    description: 'Used for important notifications',
    importance: Importance.max,
  );

  @override
  void initState() {
    super.initState();

    _initEverything();
  }

  Future<void> _initEverything() async {
    print('═' * 80);
    print('⚙️  INITIALIZING EVERYTHING');
    print('═' * 80);

    print('Loading SharedPreferences...');
    sharedPreferences = await SharedPreferences.getInstance();
    print('✅ SharedPreferences loaded');
    print('');

    print('Checking Android version...');
    await _checkAndroidVersion();
    print('✅ Android version check passed');
    print('');

    print('Initializing notifications...');
    await _initNotifications();
    print('');

    print('Initializing FCM...');
    await _initFCM();
    print('');

    print('Checking for updates...');
    await _checkForUpdate();
    print('✅ Update check complete');
    print('');

    print('Testing Firestore connection...');
    testFirestoreConnection();
    print('');

    print('═' * 80);
    print('✅ ALL INITIALIZATION COMPLETE');
    print('═' * 80);
  }

  Future<void> _checkAndroidVersion() async {
    if (!Platform.isAndroid) return;

    final info = await DeviceInfoPlugin().androidInfo;
    if (info.version.sdkInt < 31) {
      throw UnsupportedError("Android version below 12 not supported");
    }
  }


  Future<void> _initNotifications() async {
    print('═' * 80);
    print('📢 VERIFYING NOTIFICATION SETUP');
    print('═' * 80);
    print('');

    // 🔥 VERY IMPORTANT: Initialize with click handler
    const androidInit =
        AndroidInitializationSettings('@drawable/launcher_icon');
    const iosInit = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await fln.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('🔔 NOTIFICATION TAPPED (LOCAL)');
        print('Payload: ${response.payload}');

        if (response.payload != null && response.payload!.isNotEmpty) {
          final data = jsonDecode(response.payload!);
          handleNotificationNavigation(data); // 🔥 YOUR EXISTING NAVIGATION
        }
      },
    );

    // Verify channel exists
    print('Verifying notification channel...');
    try {
      final channels = await fln
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.getNotificationChannels();

      if (channels != null && channels.isNotEmpty) {
        print('✅ Found ${channels.length} notification channel(s)');
        for (var channel in channels) {
          print('   - ${channel.id}: ${channel.name}');
        }
      } else {
        print('⚠️  No notification channels found - creating one...');
        await fln
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(
              const AndroidNotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                'High Importance Notifications',
                description: 'Used for important notifications',
                importance: Importance.max,
              ),
            );
        print('✅ Notification channel created');
      }
    } catch (e) {
      print('⚠️  Error verifying channels: $e');
    }
    print('');

    // Request permissions
    print('Requesting notification permissions...');
    try {
      await fln
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      print('✅ Notification permissions requested');
    } catch (e) {
      print('⚠️  Error requesting permissions: $e');
    }
    print('');

    print('═' * 80);
    print('✅ NOTIFICATION SETUP VERIFIED');
    print('═' * 80);
  }

  Future<void> _initFCM() async {
    print('═' * 80);
    print('⏰ STORING FCM TOKEN IN SHARED PREFERENCES');
    print('═' * 80);

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print('   Token: $token');
      sharedPreferences.setString(Constants.fcmToken, token);
      print('✅ Token stored in SharedPreferences');
    } else {
      print('❌ Failed to get FCM token');
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('🔄 FCM Token refreshed at ${DateTime.now()}');
      print('   New Token: $newToken');
      sharedPreferences.setString(Constants.fcmToken, newToken);
      print('   ✅ New token stored');
    });
    print('');
    print('═' * 80);
    print('✅ FCM TOKEN HANDLING COMPLETE');
    print('═' * 80);
  }

  Future<void> _checkForUpdate() async {
    try {
      _updateInfo = await InAppUpdate.checkForUpdate();
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      Utils.print("Update check failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Miracle Manager',
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void testFirestoreConnection() async {
  try {
    final snap = await FirebaseFirestore.instance.collection('wa').get();
    Utils.print("Firestore OK: ${snap.docs.length} docs");
  } catch (e) {
    Utils.print("Firestore error: $e");
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}
 */

import 'package:customer_app_planzaa/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Planza',
      theme: ThemeData(fontFamily: 'DMSans'),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/* 
 custom app bar

bottpm navvifation bar

bootpm nav screens

login scenario ----

save in sahred prefs-----

firebase setup


other page ui -- corection



 */
