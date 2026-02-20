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

  // static const String verifyOtpUrl =
  //     'http://192.168.1.188/planzaa-live/customer-api/varify-otp';

  static const String resendOtpUrl = '';
  String email;
  OtpVerifyController(this.email, this._tickerProvider);
  Rx<LoginResponseModel> loginResponse = LoginResponseModel.fromJson({}).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    // email = Get.arguments['email'];
    //authToken = Get.arguments['auth_token']; // 👈 IMPORTANT
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

  // ---------------- VERIFY OTP ----------------
  /*   Future<void> verifyOtp(String otp) async {
    if (otp.length != 6) {
      Get.snackbar("Error", "Please enter 6-digit OTP");
      return;
    }

    // isLoading.value = true;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndpoints.verifyOtp),
        // Uri.parse(verifyOtpUrl),
      );

      request.fields['email'] = email;
      request.fields['otp'] = otp;
      request.fields['fcm_token'] = 'abc';

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('OTP VERIFY RESPONSE: $responseBody');

      final data = jsonDecode(responseBody);
      print('Data: ${data}');
      if (data['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        // await prefs.setBool("isLoggedIn", true);

        final token = data['data']['token'];
        final customer = data['data']['customer'];

        final int userId = customer['id']; // ✅ GET ID

        await TokenService.saveToken(token);
        await TokenService.saveUserId(userId); // ✅ SAVE ID

        print("Saved userId: $userId");

        Get.offAllNamed('/main');
      } else {
        Get.snackbar("Error", data['message'] ?? "Invalid OTP");
      }
    } catch (e) {
      print('OTP VERIFY ERROR: $e');
      Get.snackbar("Error", "Server error occurred");
    } finally {
      // isLoading.value = false;
    }
  }
 */
  // ---------------- RESEND OTP ----------------
  /*   Future<void> resendOtp() async {
    if (!canResend.value) return;

    try {
      final response = await http.post(
        Uri.parse(resendOtpUrl),
        headers: {'Accept': 'application/json'},
        body: {'email': email},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar("OTP Sent", data['message'] ?? "New OTP sent");
        _startTimer();
      } else {
        Get.snackbar("Error", data['message'] ?? "Failed to resend OTP");
      }
    } catch (e) {
      Get.snackbar("Error", "Unable to resend OTP");
    }
  }
 */

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
    String fcmToken = prefs.getString(Constants.fcmToken) ?? "hghg";

    List<File> files = [];

    if (kDebugMode) {
      print("fcm token : $fcmToken");
    }
    if (otp.length != 6) {
      Get.snackbar("Error", "Please enter 6-digit OTP");
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
        /*  if (statusCode == 200) {
          try {
            Constants.loginResponseModel = LoginResponseModel.fromJson(
              responseJson,
            );

            final userId = prefs.getString("user_id")!;
            final userName = prefs.getString("user_name")!;

            ZegoService.init(userID: userId, userName: userName);

            prefs.setInt(Constants.IS_LOGGED_IN, 1);
            prefs.setString(Constants.KEY_LOGIN_RESPONSE, jsonString);

            String? abcd = prefs.getString(Constants.KEY_LOGIN_RESPONSE);

            Constants.loginResponseModel = LoginResponseModel.fromJson(
              jsonDecode(abcd!),
            );

            loginResponse.value = LoginResponseModel.fromJson(jsonDecode(abcd));

            prefs.setString(
              'user_id',
              Constants.loginResponseModel!.data!.customer!.id.toString(),
            );

            await prefs.setString(
              'flutter.keyAuthToken',
              Constants.loginResponseModel!.data!.token!,
            );

            prefs.setString(
              Constants.user,
              "${Constants.loginResponseModel!.data!.customer!.name!}",
            );

            prefs.setString(
              Constants.AUTH_TOKEN,
              Constants.loginResponseModel!.data!.token!,
            );

            prefs.setString(Constants.KEY_USER_NAME, email);

            loginResponse.value.message != null &&
                    loginResponse.value.message!.isNotEmpty
                ? Utils.showToast("${loginResponse.value.message}")
                : const SizedBox();

            prefs.setString(Constants.KEY_USER_NAME, email);
            Get.offAll(() => Home());
          } catch (e) {
            e.printError();
            e.printInfo();

            if (kDebugMode) {
              print(e.toString());
            }
          }
          prefs.setInt(Constants.IS_LOGGED_IN, 1);
          prefs.setString(Constants.KEY_LOGIN_RESPONSE, jsonString);

          if (kDebugMode) {
            print("Login controller %%%%%%%%%%%%%%%%%%%% ");
          }

          prefs.setInt(Constants.IS_LOGGED_IN, 1);
          prefs.setString(Constants.KEY_LOGIN_RESPONSE, jsonString);
        } */
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
              Get.snackbar("Error", "Chat login failed");
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
