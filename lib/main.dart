import 'package:customer_app_planzaa/common/constants.dart';
import 'package:customer_app_planzaa/pages/splash_screen.dart';
import 'package:customer_app_planzaa/services/notification_service.dart';
import 'package:customer_app_planzaa/services/zego_service.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await NotificationService.init(); 
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    _navigatorKey = GlobalKey<NavigatorState>();
    // register navigator key with Zego invitation service so it can display incoming call UI
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(_navigatorKey);
    _initZego();
  }

  Future<void> _initZego() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getInt(Constants.IS_LOGGED_IN) == 1;

    if (isLoggedIn) {
      final userId = prefs.getString('user_id');
      final userName = prefs.getString('user_name');

      if (userId != null && userName != null) {
        print("🔄 Starting Zego initialization for user: $userId");
        final success = await ZegoService.login(
          userID: userId,
          userName: userName,
          navigatorKey: _navigatorKey,
        );
        
        if (success) {
          print("✅ Zego initialized for $userId");
        } else {
          print("❌ Zego initialization failed");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Planza',
      theme: ThemeData(fontFamily: 'DMSans'),
      builder: (context, child) {
        return EasyLoading.init()(
          context,
          child,
        );
      },
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      enableLog: true,
    );
  }
}
