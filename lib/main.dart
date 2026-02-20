import 'package:customer_app_planzaa/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await ZIMKit().init(
    appID: 948287968,
    appSign: "0eb5ab65ff17a3d2a0fc1300a4a9a7bb88d6e969c457cd34584ddc8ebe463808",
  );
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
