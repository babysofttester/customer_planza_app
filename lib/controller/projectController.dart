import 'dart:convert';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/modal/project_detail_response_model.dart';
import 'package:customer_app_planzaa/modal/projectmodal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class ProjectController extends GetxController {
    final TickerProvider _tickerProvider;
    
  ProjectController(this._tickerProvider);


  var projectList = <ProjectsItem>[].obs;
 // var isLoading = false.obs;
ProjectDetailResponseModel? projectDetailModel;
  @override
  void onInit() {
    fetchProjects();
    // getProjectDetails();
    super.onInit();
  }



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



  Future<void> getProjectDetails(int projectId) async {
     print("API CALLED WITH ID: $projectId"); 
    try {
        _tickerProvider;
     // isLoading.value = true;

      final token = await TokenService.getToken();

      final response = await http.post(
        Uri.parse(ApiEndpoints.projectsDetails),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {
          "project_id": projectId.toString(),
        },
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
print(response.body);

        final data = jsonDecode(response.body);
        projectDetailModel = ProjectDetailResponseModel.fromJson(data);
        update(); 
      }
    } catch (e) {
      print("Project Detail Error: $e");
    } finally {
    }
  }
}
