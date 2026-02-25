import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/modal/paymentHistoryResponseModel.dart';
import 'package:customer_app_planzaa/modal/choosePackageModel.dart' hide Result;

class PaymentHistoryController extends GetxController {
  final TickerProvider _tickerProvider;
var payments = <Result>[].obs;
  PaymentHistoryController(this._tickerProvider);

  

  String? authToken;

  @override
  Future<void> onInit() async {
    super.onInit();
    authToken = await TokenService.getToken();
    fetchPaymentHistory();
  }

  void fetchPaymentHistory() {
    if (authToken == null || authToken!.isEmpty) {
        Utils.showToast("Auth token missing");
      return;
    }

    callWebApiGet( 
      _tickerProvider,
      ApiEndpoints.paymentHistory,
      token: authToken!, 
      onResponse: (response) {
        try {
          var responseJson = jsonDecode(response.body);

          final paymentHistory =
              PaymentHistoryResponseModel.fromJson(responseJson);

          if (paymentHistory.data != null &&
              paymentHistory.data!.result != null) {
            payments.value = paymentHistory.data!.result!;
          } else {
            payments.clear();
          }
        } catch (e) {
          Utils.print(e.toString());
          Utils.showToast("Failed to parse payment history");
        }
      },
    );
  }
}