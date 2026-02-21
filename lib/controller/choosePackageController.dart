import 'dart:convert';
import 'package:customer_app_planzaa/common/load_manager.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/common/web_service.dart';
import 'package:customer_app_planzaa/core/api/api_endpoint.dart';
import 'package:customer_app_planzaa/core/storage/token_services.dart';
import 'package:customer_app_planzaa/modal/choosePackageModel.dart';
import 'package:customer_app_planzaa/modal/designnermodal.dart';
import 'package:customer_app_planzaa/pages/paymentScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
//import 'package:get/get_connect/http/src/response/response.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ChoosePackageController extends GetxController {
  final TickerProvider _tickerProvider;

  ChoosePackageController(this._tickerProvider);

  Rx<ChoosePackageResponseModel> choosePackageResponse =
      ChoosePackageResponseModel().obs;


  late SharedPreferences prefs;
  String? authToken;  

Future<void> choosePackage({
  required int projectId,
  required String packageType,
   required DesignerItem designer,
    required String jobTypeText,
  required int serviceId,
  required String serviceName,
  required String price,
}) async {

  final token = await TokenService.getToken(); 

  Map<String, String> data = {
    'project_id': projectId.toString(),
    'package_type': packageType,
  };

  callWebApi(
    _tickerProvider,
    ApiEndpoints.choosePackage,
    data,
    onResponse: (http.Response response) async {

      var responseJson = jsonDecode(response.body);

      try {
        choosePackageResponse.value =
            ChoosePackageResponseModel.fromJson(responseJson);

        if (choosePackageResponse.value.status == "success") {

          String orderNo =
              choosePackageResponse.value.data?.result?.orderNo ?? "";

          print("ORDER NO: $orderNo");

// DesignerItem? fullDesigner = await getDesignerDetails(designer.id);

// if (fullDesigner != null) {
//   Get.to(() => PaymentScreen(
//     orderNo: orderNo,
//     projectId: 102,
//     designerId: fullDesigner.id,
//     subTotal: 4800, 
//     tax: 18,
//     totalAmount: 5664,
//     item: fullDesigner,
//     jobType: jobTypeText,
//   ));
// }


  Get.to(() => PaymentScreen(
         orderNo: orderNo,
  projectId: projectId,
  designerId: designer.id,
  subTotal: double.parse(price),
  tax: 18,
  totalAmount: double.parse(price) * 1.18,
  item: designer,
  jobType: jobTypeText,
  designer: designer, 
  seriviceId: serviceId, 
  serviceName: serviceName,
  // serviceId: serviceId,
  // serviceName: serviceName,r
  // price: price,
      ));

 print("SERVICE ID: $serviceId");
print("DESIGNER ID: ${designer.id}");
print("PROJECT ID: $projectId");

        } else {
          Utils.showToast(
              choosePackageResponse.value.message ?? "Something went wrong");
        }

      } catch (e) {
        LoaderManager.hideLoader();
        e.printError();
        Utils.print(e.toString());
      }
    },

    token: token, 
  );
}


// Future<DesignerItem?> getDesignerDetails(int designerId) async {
//   final token = await TokenService.getToken();
//   final response = await http.get(
//     Uri.parse("${ApiEndpoints.designerDetail}/$designerId"),
//     headers: {'Authorization': 'Bearer $token'},
//   );

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     if (data['status'] == 'success') {
//       return DesignerItem.fromJson(data['data']);
//     }
//   }

//   return null;
// }



}
