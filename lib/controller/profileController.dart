import 'dart:convert';
import 'dart:io';
import 'package:customer_app_planzaa/common/constants.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/modal/profileModal.dart';
import 'package:customer_app_planzaa/modal/profile_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


// class ProfileController extends GetxController {
//    final TickerProvider _tickerProvider;

//    ProfileController(this._tickerProvider);

//   // RxBool isLoading = false.obs;
//   // Rx<ProfileResponseModel> profileResponseModel = ProfileResponseModel().obs;
//   // Rx<File?> profileImageFile = Rx<File?>(null);
//   //late SharedPreferences prefs;
//   File? profileImageFile; 
//   //String? authToken;
//     Customer? customer;
//     late SharedPreferences prefs;

//   @override
//   Future<void> onInit() async {
//     super.onInit();
//     prefs = await SharedPreferences.getInstance();
//    // authToken = await TokenService.getToken(); 
//     fetchProfile();
//   }

// //fetch profile

// void fetchProfile() {
//   callWebApiGet(
//     _tickerProvider,
//     ApiEndpoints.profile,
//     onResponse: (http.Response response) async {
//       var responseJson = jsonDecode(response.body);

//       try {
//         if (responseJson['status'] == "success") {
//           customer =
//               ProfileResponseModel.fromJson(responseJson)
//                   .data
//                   ?.customer;

//           update();
//         } else {
//           Utils.showToast(responseJson['message']);
//         }
//       } catch (e) {
//         Utils.print(e.toString());
//       }
//     },
//     token: Constants.authToken.toString(), 
//       // ✅ FIXED
//   );
//   print("PROFILE TOKEN: ${Constants.authToken}");

// }

//   // void fetchProfile() async {
//   //   callWebApi(
//   //      _tickerProvider,
//   //     ApiEndpoints.profile,
//   //     {},
//   //     onResponse: (http.Response response) async {
//   //       var responseJson = jsonDecode(response.body);

//   //       try {
//   //         if (responseJson['status'] == "success") {

//   //             customer =
//   //               ProfileResponseModel.fromJson(responseJson)
//   //                   .data
//   //                   ?.customer;
//   //           final customer = responseJson['data']['customer'];
//   //           profileResponseModel.value = ProfileResponseModel.fromJson(customer);

//   //           print("Profile Loaded: $customer");
//   //         } else {
//   //           Utils.showToast(responseJson['message']);
//   //         }
//   //       } catch (e) {
//   //         Utils.print(e.toString());
//   //       }
//   //     },
//   //     token: authToken,
//   //   );
//   // }



// //update profile
//   Future<void> updateProfile({
//     required String name,
//     required String email,
//     File? image,
//   }) async {
//     final userId = await TokenService.getUserId();

//     if (userId == null) {
//       Get.snackbar("Error", "User ID missing");
//       return;
//     }

//     Map<String, String> data = {
//       "id": userId.toString(),
//       "name": name,
//       "email": email,
//     };

//     callWebApi(
//       _tickerProvider,
//       ApiEndpoints.updateProfile,
//       data,
//       onResponse: (http.Response response) async {
//         var responseJson = jsonDecode(response.body);

//         try {
//           if (responseJson['status'] == "success") {
//             Utils.showToast("Profile Updated Successfully");
//             fetchProfile();
//           } else {
//             Utils.showToast(responseJson['message']);
//           }
//         } catch (e) {
//           Utils.print(e.toString());
//         }
//       },
//       token: authToken,
//     );
//   }


// }


class ProfileController extends GetxController {
  final TickerProvider _tickerProvider;

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
          if (responseJson['status'] == "success") {
            customer =
                ProfileResponseModel.fromJson(responseJson)
                    .data
                    ?.customer;

            update();
          } else {
            Utils.showToast(responseJson['message']);
          }
        } catch (e) {
          Utils.print(e.toString());
        }
      },
      token: authToken ?? "",   // ✅ SAFE TOKEN PASSING
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

    /// 🔥 Attach image if exists
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'avatar', // ⚠️ must match backend key
          image.path,
        ),
      );
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseData);

    if (jsonResponse['status'] == "success") {
      Utils.showToast("Profile Updated Successfully");

      fetchProfile(); // reload profile
      Get.back();     // go back to profile screen
    } else {
      Utils.showToast(jsonResponse['message']);
    }
  } catch (e) {
    Utils.print(e.toString());
  }
} 

}



