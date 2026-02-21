import 'dart:convert';
import 'dart:core' as Utils;
import 'dart:core';
import 'package:customer_app_planzaa/common/constants.dart';
import 'package:customer_app_planzaa/common/load_manager.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/modal/servicemodal.dart';
import 'package:customer_app_planzaa/modal/services_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceController extends GetxController {
   final TickerProvider _tickerProvider;
   ServiceController(this._tickerProvider);

  //final isLoading = false.obs;
  //final services = <ServiceItem>[].obs;
  RxList<ServiceItem> services = <ServiceItem>[].obs;
 // RxList<String> selectedServiceIds = <String>[].obs;
  RxList<int> selectedServiceIds = <int>[].obs;


  var selectedIndexes = <int>[].obs;
  bool allowMultiple = true;

  late SharedPreferences prefs;
  String? authToken;

  @override
  Future<void> onInit() async {
    super.onInit();

    prefs = await SharedPreferences.getInstance();

    authToken = prefs.getString(Constants.AUTH_TOKEN);

    print("SERVICE TOKEN: $authToken");

    fetchServices();
  }

Future<void> fetchServices() async {
  try {
   // isLoading.value = true;
_tickerProvider;
    if (authToken == null || authToken!.isEmpty) {
      print("TOKEN IS NULL");
      Get.snackbar("Error", "User not logged in");
      return;
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.service),  
      headers: {
        "Authorization": "Bearer $authToken",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData =
          jsonDecode(response.body);

      final model = ServicesResponseModel.fromJson(jsonData);

      if (model.status == "success" &&
          model.data?.services != null) {

        services.value = model.data!.services!
    .map((e) => ServiceItem.fromServiceModel(e))
    .toList(); 


      } else {
        Get.snackbar("Error",
            model.message ?? "Failed to load services");
      }

    } else {
      Get.snackbar(
          "Error", "Server Error: ${response.statusCode}");
    }

  } catch (e) {
       LoaderManager.hideLoader();
          e.printError();
          e.printInfo();
          Utils.print(e.toString());
  //  print("Service error: $e");
    Get.snackbar("Error", e.toString());
  } finally {
    _tickerProvider;
    //isLoading.value = false;
  }
}




  // Selection logic
void toggleSelection(int serviceId) {
  if (selectedServiceIds.contains(serviceId)) {
    selectedServiceIds.remove(serviceId);
  } else {
    selectedServiceIds.add(serviceId);
  }
}
  bool isSelected(int serviceId) {
  return selectedServiceIds.contains(serviceId);
}

  // bool isSelected(int index) {
  //   return selectedServiceIds.contains(services[index].id);
  // }
  
}
