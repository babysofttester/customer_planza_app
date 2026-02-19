import 'dart:convert';
import 'dart:io';

import 'package:customer_app_planzaa/common/load_manager.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/controller/dsignerController.dart';
import 'package:customer_app_planzaa/controller/servicecontroller.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/api/api_services.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/pages/designerScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AddProjectController extends GetxController {
    final TickerProvider _tickerProvider;

    AddProjectController(this._tickerProvider);

  @override
  void onInit() {
    super.onInit();
    fetchStates();
  }


  late SharedPreferences prefs;
  String? authToken;

final ServiceController serviceController = Get.find<ServiceController>();


  // Floor
  final floor = 0.obs;
  final floorController = TextEditingController(text: "0");

  // final isLoading = false.obs;

  // Images
  final ImagePicker picker = ImagePicker();
  final RxList<XFile> images = <XFile>[].obs;

  // Floor actions
  void incrementFloor() {
    floor.value++;
    floorController.text = floor.value.toString();
  }

  void decrementFloor() {
    if (floor.value > 0) {
      floor.value--;
      floorController.text = floor.value.toString();
    }
  }

  // Image pickers
   Future<void> pickFromCamera() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (image != null) {
      images.add(image);
    }
  }

  Future<void> pickFromGallery() async {
    final List<XFile> pickedImages = await picker.pickMultiImage();

    images.addAll(pickedImages);
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  void reorderImages(int oldIndex, int newIndex) {
    final item = images.removeAt(oldIndex);
    images.insert(newIndex, item);
  }
  final token =  TokenService.getToken();

  Future<List<Map<String, dynamic>>> _prepareImages() async {
    List<Map<String, dynamic>> imageList = [];

    for (final XFile image in images) {
      final bytes = await File(image.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      imageList.add({
        "file_name": image.name,
        "file_base64": base64Image,
      });
    }

    return imageList;
  }

// State & City
  final RxList<String> states = <String>[].obs;
  final RxList<String> cities = <String>[].obs;

  final RxnString selectedState = RxnString();
  final RxnString selectedCity = RxnString();

 //RxList<int> selectedServices = <int>[].obs;
 RxList<int> selectedServiceIds = <int>[].obs;
void toggleService(int serviceId) {
  if (selectedServiceIds.contains(serviceId)) {
    selectedServiceIds.remove(serviceId);
  } else {
    selectedServiceIds.add(serviceId);
  }
}


  // void toggleService(int serviceId) {
  //   if (selectedServices.contains(serviceId)) {
  //     selectedServices.remove(serviceId);
  //   } else {
  //     selectedServices.add(serviceId);
  //   }
  // }

  Future<void> addProject(
      dynamic state,
      dynamic district,
      String length,
      String breadth,
      String latitude,
      String longitude
      ) async {
        _tickerProvider;
    // isLoading.value = true;

    try {
      final token = await TokenService.getToken();

      if (token == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final preparedImages = await _prepareImages();
// List<int> serviceIds =
//     serviceController.selectedServiceIds.toList();

//     if (json['project_services'] != null) {
//   serviceIds = List<int>.from(
//     json['project_services'].map((e) => e['id'])
//   );
// }

    print("SELECTED BEFORE API: $selectedServiceIds");

      final body = {
        "state": state,
        "district": district,
        "length": double.parse(length), 
        "breadth": double.parse(breadth),
        "floor": floor.value,
        "latitude": double.parse(latitude),
        "longitude": double.parse(longitude),
        "images": preparedImages,
        //"services": selectedServices, 
       // "services": selectedServices.toList(),
       // "services": serviceController.selectedServiceIds.toList(),
       
 "services": selectedServiceIds.toList(),


      };

      final response = await http.post(
        Uri.parse(ApiEndpoints.addProject),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("Add Project response: ${response.body}");
      print("STATE: $state");
      print("DISTRICT: $district");
      print("LENGTH: $length");
      print("BREADTH: $breadth");
      print("LAT: $latitude");
      print("LONG: $longitude");
      print("IMAGES COUNT: ${images.length}");
      print("SERVICES: ${selectedServiceIds.toList()}");

print("SELECTED BEFORE API: ${serviceController.selectedServiceIds}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        // ✅ Show success snackbar
        Get.snackbar(
          "Success",
          data['message'] ?? "Project created successfully 🎉",
          // backgroundColor: Colors.green,
          // colorText: Colors.white,
          // snackPosition: SnackPosition.BOTTOM,
          // margin: const EdgeInsets.all(12),
          // duration: const Duration(seconds: 2),
        );
        // Get.snackbar("Error", "Project created successfully 🎉");
        // ✅ Small delay so user can see snackbar
        await Future.delayed(const Duration(seconds: 1));
         Get.to(() => const DesignerScreen());
        // Get.find<BottomNavController>().openInner(
        //   page: DesignerScreen(),
        //   title: "Designer",
        //   arguments: {
        //     "state": selectedState.value,
        //     "district": selectedCity.value,
        //   },
        // );
        // // 2️⃣ Then update controller
        // Get.find<DesignerController>().updateLocation(
        //   selectedState.value,
        //   selectedCity.value,
        // );
        // Get.find<BottomNavController>().openInner(
        //   page: DesignerScreen(),
        //   title: "Designer",
        // );

// Wait small time so screen builds
        await Future.delayed(const Duration(milliseconds: 200));

        Get.find<DesignerController>().updateLocation(
          state,
          district,
        );


      } else {
        Get.snackbar("Error", data['message'] ?? "Add Project failed");
      }
    } catch (e) {
      print("ADD PROJECT ERROR: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      _tickerProvider;
      
    }
  }

  
  
  //state
  // Future<void> fetchStates() async {
  //   try {
  //     _tickerProvider;
  //     final token = await TokenService.getToken();

  //     if (token == null) {
  //       Get.snackbar("Error", "User not logged in");
  //       return;
  //     }

  //     final response = await http.get(
  //       Uri.parse(ApiEndpoints.getStates),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Accept": "application/json",
  //       },
  //     );

  //     print("STATES STATUS CODE: ${response.statusCode}");
  //     print("STATES RESPONSE BODY: ${response.body}");

  //     final data = jsonDecode(response.body);

  //     if (response.statusCode == 200 && data['status'] == 'success') {
  //       states.assignAll(
  //         List<String>.from(data['data']['states']),
  //       );
  //     } else {
  //       Get.snackbar(
  //         "Error",
  //         data['message'] ?? "Failed to load states",
  //       );
  //     }
  //   } catch (e) {
  //     print("STATE API ERROR: $e");
  //     Get.snackbar("Error", "State API error");
  //   }
  // }

Future<void> fetchStates() async {
  
  final token = await TokenService.getToken();
print("STATE TOKEN: $token");


  if (token == null || token.isEmpty) {
    Get.snackbar("Error", "User not logged in");
    return;
  }
  callWebApiGet( 
    _tickerProvider,
    ApiEndpoints.getStates,
    onResponse: (http.Response response) async {

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      var responseJson = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          responseJson['status'] == "success") {

        states.assignAll(
          List<String>.from(responseJson['data']['states']),
        );

      } else {
        Utils.showToast(
            responseJson['message'] ?? "Failed to load states");
      }
    },
    token: token,
  );
}

//cities
Future<void> fetchCities(String state) async {
  final token = await TokenService.getToken();

  if (token == null) {
    Get.snackbar("Error", "User not logged in");
    return;
  }

  cities.clear();
  selectedCity.value = null;

  Map<String, String> data = {
    "state": state,
  };

  callWebApi(
    _tickerProvider,
    ApiEndpoints.getCities,
    data,
    onResponse: (http.Response response) async {
      var responseJson = jsonDecode(response.body);

      try {
        print('response: ${response}');
         print('status: ${responseJson}');
        print('response.body: ${response.body}'); 
        if (responseJson['status'] == "success") {
          cities.assignAll(
            List<String>.from(responseJson['data']['cities']),
          );
        } else {
          Utils.showToast(
              responseJson['message'] ?? "Failed to load cities");
        }
      } catch (e) {
        LoaderManager.hideLoader();
        e.printError();
        Utils.print(e.toString());
      } 
    },
    token: token,
     // token: authToken ?? "", 
   // method: HttpMethod.post, // if required
  );
}



}