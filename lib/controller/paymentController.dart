import 'dart:convert';
import 'package:customer_app_planzaa/common/load_manager.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/modal/cartDetailResponseModel.dart';
import 'package:customer_app_planzaa/modal/paymentResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentController extends GetxController {
  final TickerProvider _tickerProvider;

  PaymentController(this._tickerProvider);

  Rx<PaymentResponseModel> paymentResponseModel =
      PaymentResponseModel().obs;

      Rx<CartDetailResponseModel?> cartDetailModel =
    Rx<CartDetailResponseModel?>(null);

  late SharedPreferences prefs;

  final Razorpay _razorpay = Razorpay();


  @override
  void onInit() {
    super.onInit();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onReady() async {
    super.onReady();
    prefs = await SharedPreferences.getInstance();
  }




Future<void> getCartDetails({
  required String projectId,
  required String designerId,
}) async {
  try {
    final token = await TokenService.getToken();

    Map<String, String> data = {
      "project_id": projectId,
      "designer_id": designerId,
    };

    callWebApi(
      _tickerProvider,
      ApiEndpoints.cartDetails,
      data,
      onResponse: (http.Response response) {
        final responseJson = jsonDecode(response.body);

        cartDetailModel.value =
            CartDetailResponseModel.fromJson(responseJson);

        if (cartDetailModel.value?.status != "success") {
          Get.snackbar("Error",
              cartDetailModel.value?.message ?? "Cart load failed");
        }
      },
      token: token,
    );
  } catch (e) {
    print("CART DETAIL ERROR: $e");
  }
}




  void openCheckout({
    required String orderNumber,
    required double amount,
    required String name,
    required String description,
  }) {
    var options = {
      'key': ApiEndpoints.RazorpayApiKey,   
      'amount': (amount * 100).toInt(), 
      'name': name,
      'description': description,
   
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("RAZORPAY OPEN ERROR: $e");
    }
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Success: ${response.paymentId}");

    Get.snackbar("Success", "Payment Successful"); 

    
    await checkoutAfterPayment(response.paymentId ?? "");
  }

 
   void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.message}");
    Get.snackbar("Error", "Payment Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }


  Future<void> checkoutAfterPayment(String paymentId) async {
    try {
      final token = await TokenService.getToken();

      Map<String, String> data = {
        "payment_id": paymentId,
      };

      callWebApi(
        _tickerProvider,
        ApiEndpoints.checkout,
        data,
        onResponse: (http.Response response) async {
          var responseJson = jsonDecode(response.body);

          paymentResponseModel.value =
              PaymentResponseModel.fromJson(responseJson);

          if (paymentResponseModel.value.status == "success") {
            Get.snackbar("Success", responseJson['message']);
          } else {
            Get.snackbar("Error",
                responseJson['message'] ?? "Something went wrong");
          }
        },
        token: token,
      );
    } catch (e) {
      print("CHECKOUT ERROR: $e");
    }
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}