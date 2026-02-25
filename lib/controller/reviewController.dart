

import 'dart:convert';

import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/modal/orderDetailResponseModel.dart';
import 'package:customer_app_planzaa/modal/reviewResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ReviewController extends GetxController {
  final TickerProvider tickerProvider;

  ReviewController(this.tickerProvider);

  OrderDetailResponseModel? orderDetailModel;

  Future<void> submitReview({
  required String projectId,
  required String userType,
  required String userId,
  required int rating,
  required String comment,
}) async {
  String? token = await TokenService.getToken();

  if (token == null || token.isEmpty) {
    Utils.showToast("Token not found");
    return;
  }

  Map<String, String> body = {
    "project_id": projectId,
    "user_type": userType,
    "user_id": userId,
    "rating": rating.toString(),
    "comment": comment,
  };

  callWebApi(
    tickerProvider,
    ApiEndpoints.review,
    body,
    token: token,
    onResponse: (response) {
      final decoded = jsonDecode(response.body);
      ReviewResponseModel model =
          ReviewResponseModel.fromJson(decoded);

      if (model.status == "success") {
        Utils.showToast(model.message ?? "Review submitted");
        Get.back(); 
      } else {
        Utils.showToast(model.message ?? "Something went wrong");
      }
    },
    onError: (error) {
      Utils.showToast(error.toString());
    },
  );
}

// Future<void> getOrderDetail(String projectId) async {
//   String? token = await TokenService.getToken();

//   if (token == null || token.isEmpty) {
//     Utils.showToast("Token not found");
//     return;
//   }

//   Map<String, String> body = {
//     "project_id": projectId,
//   };

//   await callWebApi(
//     tickerProvider,
//     ApiEndpoints.ordersDetails, 
//     body,
//     token: token,
//     onResponse: (response) {
//       final decoded = jsonDecode(response.body);

//       orderDetailModel =
//           OrderDetailResponseModel.fromJson(decoded);
//     },
//     onError: (error) {
//       Utils.showToast(error.toString());
//     },
//   );
// }

}