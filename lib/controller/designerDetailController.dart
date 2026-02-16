

import 'dart:convert';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

import '../../../../core/api/api_endpoint.dart';
import '../../../../core/storage/token_services.dart';
import '../../../../modal/designerPorfolioModal.dart';
import '../../../../modal/designnermodal.dart';

class DesignerDetailController extends GetxController {
  DesignerItem? designer;
  bool isLoading = true;

  Future<void> fetchDesignerDetail(int id) async {
    try {
      isLoading = true;
      update();

      final token = await TokenService.getToken();

      final response = await http.post(
        Uri.parse(ApiEndpoints.designerDetail),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {
          "id": id.toString(),
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final result = decoded['data']['result'];

        designer = DesignerItem.fromJson(result);
      }
    } catch (e) {
      print("DETAIL ERROR: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<DesignerPortfolio?> getPortfolioDetails(int id) async {

    final token = await TokenService.getToken();

    final response = await http.post(
      Uri.parse(ApiEndpoints.portfolioDetail),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },

      body: {"id": id.toString()},
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final portfolioJson = data['data']['data'];
        return DesignerPortfolio.fromJson(portfolioJson);
      }
    }

    return null;
  }


}
