import 'dart:convert';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/modal/projectmodal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class ProjectController extends GetxController {
    final TickerProvider _tickerProvider;
    
  ProjectController(this._tickerProvider);


  var projectList = <ProjectsItem>[].obs;
 // var isLoading = false.obs;

  @override
  void onInit() {
    fetchProjects();
    super.onInit();
  }



//   @override
//   void onInit() {
//     super.onInit();
//     fetchProjects();
//   }


//  void fetchProjects() async {
//   final token = await TokenService.getToken();

//   callWebApiGet(
//     _tickerProvider,
//     ApiEndpoints.projects,
//     token: token ?? "",
//     onResponse: (response) {
//       var responseJson = jsonDecode(response.body);

//       try {
//         ProjectResponseModel model =
//             ProjectResponseModel.fromJson(responseJson);

//         if (model.status == "success") {
//           projectList.value = model.data?.result ?? [];
//         } else {
//           Utils.showToast(model.message ?? "Something went wrong");
//         }
//       } catch (e) {
//         Utils.print(e.toString()); 
//       }
//     },
//   );
// }


// class ProjectController extends GetxController {
//     final TickerProvider _tickerProvider;
    
//   ProjectController(this._tickerProvider);
//  RxList<ProjectsItem> projectList = <ProjectsItem>[].obs;

//   var projectList = <ProjectsItem>[].obs;
//   //var isLoading = false.obs;


//   late SharedPreferences prefs;
//   String? authToken; 

  
//   @override
//   void onInit() {
//     //authToken = prefs.getString(Constants.AUTH_TOKEN);

//     fetchProjects();
//     super.onInit();
//   }
// void fetchProjects() {
//   callWebApiGet(
//     _tickerProvider,
//     ApiEndpoints.projects,
//     onResponse: (http.Response response) async {
//       var responseJson = jsonDecode(response.body);

//       try {
//         if (responseJson["status"] == "success") {

//           List result = responseJson['data']['result'];

//           projectList.value =
//               result.map((e) => ProjectsItem.fromJson(e)).toList();

//           update(); 
//         } else {
//           Utils.showToast(responseJson["message"].toString());
//         }
//       } catch (e) {
//         Utils.print(e.toString()); 
//       }
//     },
//     token: authToken ?? "",
//   );
// }


  Future<void> fetchProjects() async {
    try {
      _tickerProvider;
      //isLoading.value = true;
      final token = await TokenService.getToken();
      final response = await http.get(

        Uri.parse(ApiEndpoints.projects),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);
        print("data: ${data}");
        print("Status Code: ${response.statusCode}");
        print("Body: ${response.body}");


        List result = data['data']['result'];

        projectList.value =
            result.map((e) => ProjectsItem.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      _tickerProvider;
     // isLoading.value = false;
    }
  } 
}
