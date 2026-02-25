import 'dart:convert';

import 'package:customer_app_planzaa/common/constants.dart';
import 'package:customer_app_planzaa/common/load_manager.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/modal/choosePackageModel.dart' hide Result;
import 'package:customer_app_planzaa/modal/orderDetailResponseModel.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_connect/http/src/response/response.dart' as http;
import 'package:http/http.dart' as http;

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart'; 
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailController extends GetxController {
  final TickerProvider tickerProvider;

  String bookingNo;

  OrderDetailController(this.tickerProvider, this.bookingNo);

  Rxn<Result> orderDetail = Rxn<Result>();
 
 Rx<OrderDetailResponseModel> orderDetailModel =
      OrderDetailResponseModel().obs;

 late SharedPreferences prefs;
  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
   // await fetchOrderDetail(bookingNo.toString());
     fetchOrderDetail(bookingNo); 
  }


  Future<void> fetchOrderDetail(String bookingNo) async {
    Utils.print("bookingNo:: $bookingNo");
    final authToken = prefs.getString(Constants.AUTH_TOKEN);

    Utils.print("auth token: $authToken");

    // if (authToken == null || authToken.isEmpty) {
    //   Get.snackbar("Error", "Session expired. Please login again.");
    //   return;
    // }

    Map<String, String> data = {
      "booking_no": bookingNo,
    };

    callWebApi(
      tickerProvider,
      ApiEndpoints.ordersDetails,
      data, 
      // token: authToken, 
      onResponse: (http.Response response) async {
        var responseJson = jsonDecode(response.body);
       try {
  orderDetailModel.value =
      OrderDetailResponseModel.fromJson(responseJson);

  orderDetail.value =
      orderDetailModel.value.data?.result; 
  if (orderDetailModel.value.message != null &&
      orderDetailModel.value.message!.isNotEmpty) {
    Utils.showToast(orderDetailModel.value.message!);
  }

  LoaderManager.hideLoader();
} catch (e) {
        e.printError();
        e.printInfo();
        LoaderManager.hideLoader();
        Utils.print(e.toString());
      }
       Utils.print("order detail page %%%%%%%%%%%%%%%%%%%% ");



        // OrderDetailResponseModel model =
        //     OrderDetailResponseModel.fromJson(responseJson);

        // if (model.status == "success") {
        //   orderDetail.value = model.data?.result;
        // } else {
        //   Utils.showToast(model.message ?? "Something went wrong");
        // }

        // LoaderManager.hideLoader();
      },
    token: authToken);
  } 
}