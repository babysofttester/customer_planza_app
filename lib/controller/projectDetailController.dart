


import 'dart:convert';

import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/modal/project_detail_response_model.dart';
import 'package:customer_app_planzaa/modal/projectmodal.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

class ProjectDetailController extends GetxController {
    final TickerProvider _tickerProvider;
    
  ProjectDetailController(this._tickerProvider);


ProjectDetailResponseModel? projectDetailModel;


Future<void> getProjectDetails(int projectId) async {
  print("API CALLED WITH ID: $projectId");

  try {
    final token = await TokenService.getToken();

    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    Map<String, dynamic> data = {
      "project_id": projectId.toString(),
    };

    callWebApi(
      _tickerProvider,
      ApiEndpoints.projectsDetails,
      data,
      token: token,
      onResponse: (http.Response response) async {
        print("status code : ${response.statusCode}");
        print("BODY: ${response.body}");

       final responseJson = jsonDecode(response.body);

try {
  projectDetailModel =
      ProjectDetailResponseModel.fromJson(responseJson);

  if (response.statusCode == 200 &&
      responseJson['status'] == "success") {

    update();
  } else {
    Utils.showToast(
        responseJson['message'] ?? "Failed to load project details");
  }
} catch (e) {
  print("Parsing Error: $e");
  Utils.showToast("Something went wrong");
}

      },
      onError: () {
        Utils.showToast("Project details API failed");
      },
    );
  } catch (e) {
    print("Project Detail Error: $e");
    Utils.showToast("Something went wrong");
  }
}

}
