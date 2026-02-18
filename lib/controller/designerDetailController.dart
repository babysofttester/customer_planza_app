

// import 'dart:convert';

// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:http/http.dart' as http;

// import '../../../../core/api/api_endpoint.dart';
// import '../../../../core/storage/token_services.dart';
// import '../../../../modal/designerPorfolioModal.dart';
// import '../../../../modal/designnermodal.dart';

// class DesignerDetailController extends GetxController {
//   DesignerItem? designer;
//   bool isLoading = true;

//   Future<void> fetchDesignerDetail(int id) async {
//     try {
//       isLoading = true;
//       update();

//       final token = await TokenService.getToken();

//       final response = await http.post(
//         Uri.parse(ApiEndpoints.designerDetail),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//         },
//         body: {
//           "id": id.toString(),
//         },
//       );

//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);

//         final result = decoded['data']['result'];

//         designer = DesignerItem.fromJson(result);
//       }
//     } catch (e) {
//       print("DETAIL ERROR: $e");
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }

//   Future<DesignerPortfolio?> getPortfolioDetails(int id) async {

//     final token = await TokenService.getToken();

//     final response = await http.post(
//       Uri.parse(ApiEndpoints.portfolioDetail),
//       headers: {
//         "Authorization": "Bearer $token",
//         "Accept": "application/json",
//       },

//       body: {"id": id.toString()},
//     );

//     if (response.statusCode == 200) {

//       final data = jsonDecode(response.body);

//       if (data['status'] == 'success') {
//         final portfolioJson = data['data']['data'];
//         return DesignerPortfolio.fromJson(portfolioJson);
//       }
//     }

//     return null;
//   }


// }

import 'dart:async';
import 'dart:convert';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/modal/designerPorfolioModal.dart';
import 'package:customer_app_planzaa/modal/designnermodal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class DesignerDetailController extends GetxController {
   final TickerProvider _tickerProvider;

   RxString innerTitle = "Designer Services".obs;

    DesignerDetailController(this._tickerProvider);
  DesignerItem? designer;
  bool isLoading = true;
  String? authToken;

  //get innerTitle => null;
 
  Future<void> fetchDesignerDetail(int id) async {
    isLoading = true;
    update();

    authToken = await TokenService.getToken();

    Map<String, String> data = {
      "id": id.toString(),
    };

    callWebApi(
      _tickerProvider,
     // null, // if your callWebApi requires tickerProvider, pass it here
      ApiEndpoints.designerDetail,
      data,
      onResponse: (http.Response response) async {
        try {
          if (response.statusCode == 200) {
            final decoded = jsonDecode(response.body);

            final result = decoded['data']['result'];

            designer = DesignerItem.fromJson(result); 
          }
        } catch (e) {
          print("DETAIL ERROR: $e");
        }

        isLoading = false;
        update();
      },
      token: authToken,
    );
  }


Future<DesignerPortfolio?> getPortfolioDetails(int id) async {
  authToken = await TokenService.getToken();

  Map<String, String> data = {
    "id": id.toString(),
  };

  final Completer<DesignerPortfolio?> completer = Completer();

  callWebApi(
    _tickerProvider,
    ApiEndpoints.portfolioDetail,
    data,
    token: authToken,
    onResponse: (http.Response response) {
      try {
        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);

          if (decoded['status'] == "success") {
            final portfolioJson = decoded['data']['data'];

            completer.complete(
              DesignerPortfolio.fromJson(portfolioJson),
            );
            return;
          }
        }

        completer.complete(null);
      } catch (e) {
        print("PORTFOLIO ERROR: $e");
        completer.complete(null);
      }
    },
    onError: (error) {
      print("API ERROR: $error");
      completer.complete(null);
    },
  );

  return completer.future;
} 

  // Future<DesignerPortfolio?> getPortfolioDetails(int id) async {
  //   authToken = await TokenService.getToken();

  //   Map<String, String> data = {
  //     "id": id.toString(),
  //   };

  //   DesignerPortfolio? portfolio;

  //   callWebApi(
  //      _tickerProvider,
  //     //null, // pass tickerProvider if required
  //     ApiEndpoints.portfolioDetail,
  //     data,
  //     onResponse: (http.Response response) async {
  //       try {
  //         if (response.statusCode == 200) {
  //           final decoded = jsonDecode(response.body);

  //           if (decoded['status'] == "success") {
  //             final portfolioJson = decoded['data']['data'];
  //             portfolio =
  //                 DesignerPortfolio.fromJson(portfolioJson);
  //           }
  //         }
  //       } catch (e) {
  //         print("PORTFOLIO ERROR: $e");
  //       }
  //     },
  //     token: authToken,
  //   );

  //   return null;
  // }


}
