import 'dart:convert';

import 'package:customer_app_planzaa/common/assets.dart';
import 'package:customer_app_planzaa/common/common_text_field.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;

import '../controller/sign_in_controller.dart';
import 'otp_verify.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  // final SignInController signInController = Get.put(SignInController());
  late SignInController signInController;
  @override
  void initState() {
    super.initState();
    signInController = Get.put(SignInController(this));
  }

  @override
  void dispose() {
    Get.delete<SignInController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.42,
              child: Image.asset(
                Assets.bgPNG,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                 width: double.infinity,
                //height: screenHeight * 0.46,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, 
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRect(
                        child: Align(
                          alignment: Alignment.center,
                          heightFactor: 1,
                          child: Image.asset(
                            // 'assets/logo.png',
                            Assets.appLogoPNG,
                            height: Get.height * 0.06,
                          ),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      SizedBox(height: Get.height * 0.019),
                      Utils.textView(
                        "Let's sign you in",
                        Get.width * 0.06,
                        CustomColors.black,
                        FontWeight.bold,
                      ),
                  
                      SizedBox(height: Get.height * 0.01),
                      Utils.textView(
                        "Welcome back! Enter your details to continue.",
                        Get.width * 0.036,
                        CustomColors.textGrey,
                        FontWeight.normal,
                      ),
                  
                      SizedBox(height: Get.height * 0.03),
                  
                      // TextField(
                      //   keyboardType: TextInputType.phone,
                      //   maxLength: 10,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly, // Allows only numbers
                      //   ],
                      //   decoration: InputDecoration(
                      //     counterText: "",
                      //     prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                      //     hintText: "Enter Registered Mobile Number",
                      //     hintStyle: const TextStyle(color: Colors.grey),
                      //
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //       borderSide: const BorderSide(color: Colors.grey),
                      //     ),
                      //
                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //       borderSide: const BorderSide(color: Color(0xFF1F3C88)),
                      //     ),
                      //   ),
                      //   cursorColor:  Color(0xFF1F3C88),
                      //
                      //
                      // ),
                      CommonTextField(
                        () {},
                        svg: Assets.emailSVG,
                        controller: signInController.emailController,
                        keyboardActionType: TextInputAction.done,
                        inputTypeKeyboard: TextInputType.emailAddress,
                        lineFormatter:
                            FilteringTextInputFormatter.singleLineFormatter,
                        hintText: "Enter Registered Email",
                        maxLength: 999,
                        obscureText: false,
                        obscure: false,
                        onChanged: () {},
                      ),
                  
                      SizedBox(height: Get.height * 0.03),
                  
                      SizedBox(
                        width: double.infinity,
                        height: Get.height * 0.06,
                        child:  ElevatedButton(
                            onPressed:signInController.sendOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.boxColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child:  Utils.textView(
                                    "OTP",
                  
                                    Get.height * 0.02,
                                    CustomColors.white,
                                    FontWeight.bold,
                                  ),
                          ),
                        ),
                      
                  
                      SizedBox(height: Get.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // const Text("Don't have an account?"),
                          Utils.textView(
                            "Don't have an account?",
                            Get.height * 0.018,
                            CustomColors.black,
                            FontWeight.normal,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpPage(),
                                ),
                              );
                            },
                            child: Utils.textView(
                              "Register",
                              Get.height * 0.018,
                              CustomColors.boxColor,
                              FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                  
                      // const SizedBox(height: 10),
                      // Row(
                      //   children: const [
                      //     Expanded(
                      //       child: Divider(
                      //         thickness: 1,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //     Padding(
                      //       padding: EdgeInsets.symmetric(horizontal: 8),
                      //       child: Text(
                      //         "Or sign in with",
                      //         style: TextStyle(color: Colors.grey),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Divider(
                      //         thickness: 1,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      //
                      // const SizedBox(height: 30),
                      //
                      // // Google
                      // OutlinedButton.icon(
                      //   onPressed: () {},
                      //   icon: Image.asset(
                      //     'assets/google.png',
                      //     height: 20,
                      //     width: 20,
                      //   ),
                      //   label: const Text(
                      //     "Continue with Google",
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      //   style: OutlinedButton.styleFrom(
                      //     minimumSize: const Size(double.infinity, 48),
                      //     side: const BorderSide(
                      //       color: Colors.grey, // border color
                      //     ),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     backgroundColor: Colors.white,
                      //   ),
                      // ),
                      //
                      //
                      // const SizedBox(height: 10),
                      //
                      // // Facebook
                      // ElevatedButton.icon(
                      //   onPressed: () {},
                      //   icon: const Icon(
                      //     Icons.facebook,
                      //     color: Colors.white,
                      //     size: 22,
                      //   ),
                      //   label: const Text(
                      //     "Continue with Facebook",
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: const Color(0xFF4267B2),
                      //     minimumSize: const Size(double.infinity, 48),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     elevation: 0,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
