import 'dart:convert';
import 'package:customer_app_planzaa/common/load_manager.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/modal/paymentResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  final TickerProvider _tickerProvider;

  PaymentController(this._tickerProvider);

   Rx<PaymentResponseModel> paymentResponseModel = PaymentResponseModel().obs;

  Future<void> checkout({
    required String orderNumber,
    required int projectId,
    required int designerId,
    required double subTotal,
    required double tax,
    required double totalAmount,
  }) async {
    try {
      final token = await TokenService.getToken();

      Map<String, String> data = {
        "order_number": orderNumber,
        "project_id": projectId.toString(),
        "job_type": "designer",
        "designer_id": designerId.toString(),
        "sub_total": subTotal.toString(),
        "tax": tax.toString(),
        "total_amount": totalAmount.toString(),
      };

      
      callWebApi(
        _tickerProvider,
        ApiEndpoints.checkout,
        data,
        onResponse: (http.Response response) async {
            var responseJson = jsonDecode(response.body);
          try {
            Utils.print("CHECKOUT RESPONSE: ${response.body}");
             paymentResponseModel.value = PaymentResponseModel.fromJson(
            responseJson,
          );
            // final responseJson = jsonDecode(response.body);

            if (paymentResponseModel.value.status == "success") {
              Get.snackbar("Success", responseJson['message']);

              Utils.print("ORDER NO: ${responseJson['data']['order_number']}");
              Utils.print("BOOKING NO: ${responseJson['data']['booking_no']}");
              Utils.showToast("${paymentResponseModel.value.error}");
            } else {
              Get.snackbar("Error", responseJson['message'] ?? "Something went wrong");
            }
          } catch (e) {
            LoaderManager.hideLoader();
            e.printError();
            Utils.print("Checkout parsing error: $e");
          }
        },
        token: token,
      );
    } catch (e) {
      print("CHECKOUT ERROR: $e");
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
