import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/api/api_endpoint.dart' show ApiEndpoints;
import '../../../../core/storage/token_services.dart';
import '../../../../modal/projectmodal.dart';


class ProjectController extends GetxController {
  var projectList = <ProjectsItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchProjects();
    super.onInit();
  }


  Future<void> fetchProjects() async {
    try {
      isLoading.value = true;
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
      isLoading.value = false;
    }
  }
}
