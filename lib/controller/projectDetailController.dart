


import 'dart:convert';

import 'package:customer_app_planzaa/common/constants.dart';
import 'package:customer_app_planzaa/common/load_manager.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/modal/project_detail_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProjectDetailController extends GetxController {
    final TickerProvider _tickerProvider;
    int projectId;

  ProjectDetailController(this._tickerProvider, this.projectId );

  Rx<ProjectDetailResponseModel> projectDetailModel =
      ProjectDetailResponseModel().obs;
 late SharedPreferences prefs;
  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    await getProjectDetails(projectId.toString());
  }
/* 
Future<void> getProjectDetails() async {
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

 */

  getProjectDetails(String pID) {
    Utils.print("pID:: $pID");

    var authToken = prefs.getString(Constants.AUTH_TOKEN);

    Utils.print("auth token: $authToken");
    Map<String, String> data = {
      "project_id": pID,
    };

    callWebApi( _tickerProvider,   ApiEndpoints.projectsDetails, data,
        onResponse: (http.Response response) async {
      var responseJson = jsonDecode(response.body);

      try {
        projectDetailModel.value =
            ProjectDetailResponseModel.fromJson(responseJson);

        projectDetailModel.value.message == null ||
                projectDetailModel.value.message == ""
            ? const SizedBox()
            : Utils.showToast(
                "${projectDetailModel.value.message}");
        // gotPropertyDetailData.value = true;
        // gotPropertyDetailDataBU.value = true;
        LoaderManager.hideLoader();
      } catch (e) {
        e.printError();
        e.printInfo();
        LoaderManager.hideLoader();
        Utils.print(e.toString());
      }
      // loading.value = false;
      Utils.print("project detail page %%%%%%%%%%%%%%%%%%%% ");
    }, token: authToken);
  }


}
