import 'package:customer_app_planzaa/common/assets.dart';
import 'package:customer_app_planzaa/common/common_text_field.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart' show Utils;
import 'package:customer_app_planzaa/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:planzaa_app/module/login/screen/sign_in_page.dart';

import '../controller/sign_up_controller.dart';
import 'otp_verify.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  late SignUpController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(SignUpController(this));
  }

  @override
  void dispose() {
    Get.delete<SignUpController>();
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
              bottom: MediaQuery.of(context).size.height * 0.55,
              child: Image.asset(
                Assets.bgPNG,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            // Positioned(
            //   top: 60,
            //   right: 40,
            //   child: Container(
            //     height: 80,
            //     width: 100,
            //     // decoration: BoxDecoration(
            //     //   color: Colors.white.withOpacity(0.15),
            //     //   shape: BoxShape.circle,
            //     // ),
            //   ),
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenHeight * 0.6,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const SizedBox(height: 10),
                      ClipRect(
                        child: Align(
                          alignment: Alignment.center,
                          heightFactor: 1,
                          child: Image.asset(
                            Assets.appLogoPNG,
                            height: Get.height * 0.06,
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.019),

                      // const SizedBox(height: 20),
                      Utils.textView(
                        "Let's create your account",
                        Get.width * 0.058,
                        CustomColors.black,
                        FontWeight.bold,
                      ),
                      SizedBox(height: Get.height * 0.01),

                      Utils.textView(
                        "Sign up to get started with survey, design, and engineering solutions.",
                        Get.width * 0.036,
                        CustomColors.hintColor,
                        FontWeight.normal,
                      ),

                      SizedBox(height: Get.height * 0.05),

                      // TextField(
                      //   controller: controller.phoneController,
                      //   keyboardType: TextInputType.phone,
                      //   maxLength: 10,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //   ],
                      //   decoration: InputDecoration(
                      //     counterText: "",
                      //     prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                      //     hintText: "Enter your Mobile Number",
                      //     hintStyle: const TextStyle(color: Colors.grey),

                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),

                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //       borderSide: const BorderSide(color: Colors.grey),
                      //     ),

                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //       borderSide: const BorderSide(color: Color(0xFF1F3C88)),
                      //     ),
                      //   ),
                      //   cursorColor:  Color(0xFF1F3C88),

                      // ),
                      CommonTextField(
                        () {},
                        svg: Assets.callSVG,
                        controller: controller.phoneController,
                        keyboardActionType: TextInputAction.done,
                        inputTypeKeyboard: TextInputType.phone,
                        lineFormatter:
                            FilteringTextInputFormatter.singleLineFormatter,
                        hintText: "Enter your Mobile Number",
                        maxLength: 10,
                        obscureText: false,
                        obscure: false,
                        onChanged: () {},
                      ),

                      SizedBox(height: Get.height * 0.03),

                      // TextField(
                      //   controller: controller.emailController,
                      //   keyboardType: TextInputType.emailAddress,

                      //   decoration: InputDecoration(
                      //     counterText: "",
                      //     prefixIcon: const Icon(Icons.email, color: Colors.grey),
                      //     hintText: "Enter your Email",
                      //     hintStyle: const TextStyle(color: Colors.grey),

                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),

                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //       borderSide: const BorderSide(color: Colors.grey),
                      //     ),

                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //       borderSide: const BorderSide(color: Color(0xFF1F3C88)),
                      //     ),
                      //   ),
                      //   cursorColor:  Color(0xFF1F3C88),

                      // ),
                      CommonTextField(
                        () {},
                        svg: Assets.emailSVG,
                        controller: controller.emailController,
                        keyboardActionType: TextInputAction.done,
                        inputTypeKeyboard: TextInputType.emailAddress,
                        lineFormatter:
                            FilteringTextInputFormatter.singleLineFormatter,
                        hintText: "Enter your Email",
                        maxLength: 999,
                        obscureText: false,
                        obscure: false,
                        onChanged: () {},
                      ),

                      SizedBox(height: Get.height * 0.03),

                      SizedBox(
                        width: double.infinity,
                        height: Get.height * 0.06,
                        child: ElevatedButton(
                          onPressed: controller.register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1F3C88),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Utils.textView(
                            "Send OTP",

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
                          Utils.textView(
                            "Already have an account?",
                            Get.height * 0.018,
                            CustomColors.black,
                            FontWeight.normal,
                          ),
                          // const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInPage(),
                                ),
                              );
                            },
                            child: Utils.textView(
                              "Log In",
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
