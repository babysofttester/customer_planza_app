import 'dart:convert';
import 'dart:io';
import 'package:customer_app_planzaa/common/constants.dart';
import 'package:customer_app_planzaa/common/load_manager.dart';
import 'package:customer_app_planzaa/common/multipart_api_call.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart' as api;
import 'package:customer_app_planzaa/modal/login_response_model.dart';
import 'package:customer_app_planzaa/modal/sign_in_response_model.dart';
import 'package:customer_app_planzaa/pages/home.dart';
import 'package:customer_app_planzaa/services/zego_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_endpoint.dart';

class OtpVerifyController extends GetxController {
  late String authToken;
  late SharedPreferences prefs;
  final TickerProvider _tickerProvider;
  Rx<SignInResponseModel> signInResponseModel = SignInResponseModel().obs;

  // final isLoading = false.obs;
  final secondsRemaining = 30.obs;
  final canResend = false.obs;



  static const String resendOtpUrl = '';
  String email;
  OtpVerifyController(this.email, this._tickerProvider);
  Rx<LoginResponseModel> loginResponse = LoginResponseModel.fromJson({}).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
  
    _startTimer();
  }

  // ---------------- TIMER ----------------
  void _startTimer() {
    secondsRemaining.value = 30;
    canResend.value = false;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (secondsRemaining.value == 0) {
        canResend.value = true;
        return false;
      }
      secondsRemaining.value--;
      return true;
    });
  }

 

  resendOtp() async {
    Map<String, String> data = {'email': email};

    api.callWebApi(
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
      token: "",
    );
  }

  verifyOtp(String otp) async {
    String fcmToken = prefs.getString(Constants.fcmToken) ?? "";

    List<File> files = [];

    if (kDebugMode) {
      print("fcm token : $fcmToken");
    }
    if (otp.length != 6) {
          Utils.showToast("Error: Please enter 6-digit OTP");
      return;
    }
    Map<String, String> data = {
      "email": email,
      "otp": otp,
      "fcm_token": fcmToken.toString(),
    };
    callMultipartWebApi(
      _tickerProvider,
      ApiEndpoints.verifyOtp,
      data,
      files,
      onResponse: (response) async {
        Utils.print("response:: $response");

        var responseJson =
            jsonDecode(response.body);

        String jsonString = jsonEncode(responseJson);

        int statusCode = response.statusCode;
        if (kDebugMode) {
          print("statusCode::::: $statusCode");
        }
       
        if (statusCode == 200) {
          try {
            final loginModel = LoginResponseModel.fromJson(responseJson);

            final userId = loginModel.data!.customer!.id.toString();
            final userName = loginModel.data!.customer!.name ?? "User";

            /// ✅ SAVE DATA FIRST
            await prefs.setInt(Constants.IS_LOGGED_IN, 1);
            await prefs.setString(Constants.KEY_LOGIN_RESPONSE, jsonString);

            await prefs.setString('user_id', userId);
            await prefs.setString('user_name', userName);
            await prefs.setString(
                Constants.AUTH_TOKEN, loginModel.data!.token!);

            // /// ✅ THEN INIT ZEGO
            // await ZegoService.init(
            //   userID: userId,
            //   userName: userName,
            // );
            final isSuccess = await ZegoService.login(
              userID: userId,
              userName: userName,
            );

            if (!isSuccess) {
                  Utils.showToast("Error: Chat login failed");
              return;
            }

            /// Optional success toast
            if (loginModel.message != null && loginModel.message!.isNotEmpty) {
              Utils.showToast(loginModel.message!);
            }

            /// ✅ Navigate after Zego ready
            Get.offAll(() => Home());
          } catch (e) {
            print("Login parsing error: $e");
          }
        } else {
          Utils.print(responseJson['statusCode']);
          Utils.print(responseJson['statusCode']);
          Utils.showToast(responseJson['error']);
        }
      },
      token: "",
    );
  }
}
