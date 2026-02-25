import 'package:customer_app_planzaa/modal/choosePackageModel.dart' hide Result;
import 'package:customer_app_planzaa/modal/orderHistoryResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer_app_planzaa/modal/orderModal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';


class OrderHistoryController extends GetxController {
  final TickerProvider _tickerProvider;
  var orders = <Result>[].obs;

  OrderHistoryController(this._tickerProvider);

  String? authToken;

  @override
  Future<void> onInit() async {
    super.onInit();
    authToken = await TokenService.getToken(); 
     fetchOrders(); 
  }

 
  void fetchOrders() {
    if (authToken == null || authToken!.isEmpty) {
          Utils.showToast("Error: Auth token missing");
      // Get.snackbar("Error", "Auth token missing");
      return;
    }

    callWebApiGet(
      _tickerProvider,
      ApiEndpoints.orders, 
      token: authToken!,
      onResponse: (response) {
        try {
          var responseJson = jsonDecode(response.body);
          final orderHistory = OrderHistoryResponseModel.fromJson(responseJson);
          print('responseJson: ${responseJson}');
          print('orderHistory: ${orderHistory}');


          if (orderHistory.data != null && orderHistory.data!.result != null) {
            orders.value = orderHistory.data!.result!;
          } else {
            orders.clear();
          }
        } catch (e) {
          Utils.print(e.toString());
          Utils.showToast("Failed to parse orders");
        }
      },
    );
  }
}