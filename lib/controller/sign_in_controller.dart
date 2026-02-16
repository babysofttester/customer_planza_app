import 'dart:convert';
import 'package:customer_app_planzaa/common/constants.dart';
import 'package:customer_app_planzaa/common/load_manager.dart';
import 'package:customer_app_planzaa/common/multipart_api_call.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/modal/sign_in_response_model.dart';
import 'package:customer_app_planzaa/pages/otp_verify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_endpoint.dart';

class SignInController extends GetxController {
  final TickerProvider _tickerProvider;

  SignInController(this._tickerProvider);

  final emailController = TextEditingController();
  // final isLoading = false.obs;
  Rx<SignInResponseModel> signInResponseModel = SignInResponseModel().obs;
  String? authToken;
  late SharedPreferences prefs;
  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
  }

  sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter email");
      return;
    }

    Map<String, String> data = {'email': email};

    callWebApi(
      _tickerProvider,
      ApiEndpoints.sendOtp,
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

        Utils.print("sign in controller %%%%%%%%%%%%%%%%%%%% ");
      },
      token: authToken,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
