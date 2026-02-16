import 'dart:convert';

import 'package:customer_app_planzaa/common/load_manager.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/modal/sign_in_response_model.dart';
import 'package:customer_app_planzaa/pages/otp_verify.dart';
import 'package:customer_app_planzaa/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:http/http.dart' as http;
import '../../../core/api/api_endpoint.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  Rx<SignInResponseModel> signInResponseModel = SignInResponseModel().obs;

  // final isLoading = false.obs;

  final TickerProvider _tickerProvider;

  SignUpController(this._tickerProvider);

  // static const String registerUrl =
  //     '192.168.1.188/planzaa-live/customer-api/register';
  /* 
  Future<void> register() async {
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    if (email.isEmpty || phone.isEmpty) {
      Get.snackbar("Error", "Email and phone are required");
      return;
    }


    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndpoints.register),
        //Uri.parse(registerUrl),
      );

      request.fields['email'] = email;
      request.fields['phone'] = phone;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

       print('Sign up response: $responseBody');

      final data = jsonDecode(responseBody);
      print("data: ${data}");

      if (data['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        // await prefs.setBool("isLoggedIn", true);
        await prefs.setString("email", email);
        Get.toNamed(
          '/otp',
          arguments: {
            "email": email,
            "from": "register",
          },
        );
      } else {
        Get.snackbar("Error", data['message'] ?? "Registration failed");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
 */

  register() async {
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    if (email.isEmpty || phone.isEmpty) {
      Get.snackbar("Error", "Email and phone are required");
      return;
    }

    Map<String, String> data = {'email': email, "phone": phone, };

    callWebApi(
      _tickerProvider,
     ApiEndpoints.register,
      data,
      onResponse: (http.Response response) async {
        var responseJson = jsonDecode(response.body);
        try {
          signInResponseModel.value = SignInResponseModel.fromJson(
            responseJson,
          );
          if (signInResponseModel.value.status == "success") {
            Get.to(() => OtpVerify(email: email));
          } else if (signInResponseModel.value.error == null ||
              signInResponseModel.value.error == "") {
            Utils.showToast("${signInResponseModel.value.error}");
          }
        } catch (e) {
          LoaderManager.hideLoader();
          e.printError();
          e.printInfo();
          Utils.print(e.toString());
        }

        Utils.print("sign up controller %%%%%%%%%%%%%%%%%%%% ");
      },
      token: "",
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
