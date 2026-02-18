// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:http/http.dart' as http;

// import '../../../../core/api/api_endpoint.dart';
// import '../../../../core/storage/token_services.dart';
// import '../../../../modal/designnermodal.dart';

// class DesignerController extends GetxController {

//   final TickerProvider _tickerProvider;

//     DesignerController(this._tickerProvider);


//   List<DesignerItem> designers = [];
//   String currencySymbol = "₹";
//   // bool isLoading = true;

//   String? state;
//   String? district;


//   @override
//   void onInit() {
//     super.onInit();
//     print("DesignerController INIT called");
//   }

//   Future<void> fetchDesigners() async {
//     if (state == null || district == null) {
//       print("State or District is null. Skipping API call.");
//       return;
//     }
//     print("fetchDesigners CALLED");
//     try {
//       final token = await TokenService.getToken();

//       // 🔥 Clear before API call
//       designers = [];
//       _tickerProvider;
//       // isLoading = true;
//       update();
//       print("Calling API with:");
//       print("State: $state");
//       print("District: $district");


//       final response = await http.post(
//         Uri.parse(ApiEndpoints.designer),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "state": state,
//           "district": district,
//         }),
//       );

//       print("Status Code: ${response.statusCode}");
//       print("Response: ${response.body}");
//       if (response.statusCode == 200) {
//         final decoded = json.decode(response.body);

//         if (decoded['data'] != null &&
//             decoded['data']['data'] != null) {

//           final Map<String, dynamic> designersMap =
//           decoded['data']['data'];

//           currencySymbol =
//               designersMap['currancy_symbol'] ?? "₹";

//           List<DesignerItem> tempList = [];

//           designersMap.forEach((key, value) {
//             if (key != "currancy_symbol" &&
//                 value is Map<String, dynamic>) {
//               tempList.add(
//                 DesignerItem.fromJson(value),
//               );
//             }
//           });
//           if (tempList.isEmpty) {
//             designers = []; // ensure empty
//           } else {
//             designers = tempList;
//           }

//          designers = tempList;
//         } else {
//           designers = [];
//         }
//       } else {
//         designers = [];
//       }
//     } catch (e) {
//       designers = [];
//       print("Error: $e");
//     } finally {
//       _tickerProvider;
//       // isLoading = false;
//       update();
//     }
//   }

//   void updateLocation(String newState, String newDistrict) {
//     state = newState;
//     district = newDistrict;

    
//     designers = [];
//     _tickerProvider;
//     // isLoading = true;
//     update();

//     fetchDesigners();
//   }




// }


import 'dart:convert';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/modal/designnermodal.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class DesignerController extends GetxController {
  final TickerProvider _tickerProvider;

  DesignerController(this._tickerProvider);

  List<DesignerItem> designers = [];
  String currencySymbol = "₹";

  String? state;
  String? district;
  String? authToken;

  @override
  void onInit() {
    super.onInit();
    print("DesignerController INIT called");
  }

  Future<void> fetchDesigners() async {
    if (state == null || district == null) {
      print("State or District is null. Skipping API call.");
      return;
    }

    authToken = await TokenService.getToken();

    Map<String, String> data = {
      "state": state ?? "",
      "district": district ?? "",
    };

    designers = [];
    update();

    callWebApi(
      _tickerProvider,
      ApiEndpoints.designer,
      data,
      onResponse: (http.Response response) async {
        try {
          print("Status Code: ${response.statusCode}");
          print("Response: ${response.body}");

          if (response.statusCode == 200) {
            final decoded = jsonDecode(response.body);

            if (decoded['data'] != null &&
                decoded['data']['data'] != null) {

              final Map<String, dynamic> designersMap =
                  decoded['data']['data'];

              currencySymbol =
                  designersMap['currancy_symbol'] ?? "₹";

              List<DesignerItem> tempList = [];

              designersMap.forEach((key, value) {
                if (key != "currancy_symbol" &&
                    value is Map<String, dynamic>) {
                  tempList.add(
                    DesignerItem.fromJson(value),
                  );
                }
              });

              designers = tempList;
            } else {
              designers = [];
            }
          } else {
            designers = [];
          }
        } catch (e) {
          designers = [];
          print("Error: $e");
        }

        update();
      },
      token: authToken,
    );
  }

  void updateLocation(String newState, String newDistrict) {
    state = newState;
    district = newDistrict;

    designers = [];
    update();

    fetchDesigners(); 
  }
}

