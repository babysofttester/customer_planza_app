import 'dart:convert';
import 'dart:io';
import 'package:customer_app_planzaa/common/constants.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/modal/profile_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class ProfileController extends GetxController {
  final TickerProvider _tickerProvider;
  Rx<ProfileResponseModel> profileResponseModel = ProfileResponseModel().obs;

  ProfileController(this._tickerProvider);

  File? profileImageFile;
  Customer? customer;

  late SharedPreferences prefs;
  String? authToken;  

  @override
  Future<void> onInit() async {
    super.onInit();

    prefs = await SharedPreferences.getInstance();

    
    //authToken = prefs.getString("auth_token");
     authToken = prefs.getString(Constants.AUTH_TOKEN);

    print("PROFILE TOKEN: $authToken");

fetchProfile(); 

    // if (authToken != null && authToken!.isNotEmpty) {
    //   fetchProfile();
    // } else {
    //   Get.offAllNamed('/login'); // or your SignInPage
    // }
  }

  // ✅ FETCH PROFILE
  void fetchProfile() {
    callWebApiGet(
      _tickerProvider,
      ApiEndpoints.profile,
      onResponse: (http.Response response) async {
        var responseJson = jsonDecode(response.body);

        try {
           profileResponseModel.value =
            ProfileResponseModel.fromJson(responseJson);

        if (profileResponseModel.value.status == "success") {
          // profileResponseModel.value = model;
          customer = profileResponseModel.value.data?.customer;
          print("AVATAR URL: ${customer?.avatar}");

          update(); 
        } else {
          Utils.showToast(profileResponseModel.value.message.toString());
        }
          // if (profileResponseModel.value.status == "success") {
          //   customer =
          //       ProfileResponseModel.fromJson(responseJson)
          //           .data
          //           ?.customer;

          //   update(); 
          // } else {
          //   Utils.showToast(profileResponseModel.value.message.toString());
          // }
        } catch (e) {
          Utils.print(e.toString());
        }
      },
      token: authToken ?? "",   
    ); 
  }

 
 
  // ✅ UPDATE PROFILE
Future<void> updateProfile({
  required String name,
  required String email,
  File? image,
}) async {
  final userId = await TokenService.getUserId();

  if (userId == null) {
    Get.snackbar("Error", "User ID missing");
    return;
  } 
  try {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(ApiEndpoints.updateProfile),
    ); 

    request.headers['Authorization'] = 'Bearer $authToken';

    request.fields['id'] = userId;
    request.fields['name'] = name;
    request.fields['email'] = email;

    
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'avatar', 
          image.path,
        ),
      );
    }

   var response = await request.send();
   var responseData = await response.stream.bytesToString();
   var jsonResponse = jsonDecode(responseData);


if (jsonResponse["status"] == "success") {
  Utils.showToast("Profile Updated Successfully");
  fetchProfile(); 
  Get.back();
} else {
  Utils.showToast(jsonResponse["message"]);
}


    // if (profileResponseModel.value.status == "success") {
    //   Utils.showToast("Profile Updated Successfully");

    //   fetchProfile(); 
    //   Get.back();    
    // } else {
    //   Utils.showToast(profileResponseModel.value.message.toString());
    // }
  } catch (e) {
    Utils.print(e.toString());
  }
} 

}



