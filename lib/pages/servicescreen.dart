import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/projectController.dart';
import 'package:customer_app_planzaa/controller/servicecontroller.dart';
import 'package:customer_app_planzaa/custom_widgets/architectpopup.dart';
import 'package:customer_app_planzaa/pages/servicecard.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';



class ServiceScreen extends StatefulWidget {

  const ServiceScreen({super.key,});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with TickerProviderStateMixin {

  late final ServiceController serviceController;

  @override
  void initState() {
    super.initState();

    serviceController = Get.put(ServiceController(this));
  }
final projectController = Get.find<ProjectController>();



  @override
  Widget build(BuildContext context) {
    
 return Scaffold(
  backgroundColor: Colors.white,
  body: SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          
          /// List
      Expanded(
  child: ListView.builder(
    physics: const NeverScrollableScrollPhysics(), 
    itemCount: serviceController.services.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ServiceCard(
          item: serviceController.services[index],
          index: index,
          compact: true,
        ),
      );
    },
  ),
),


          /// Button
          SizedBox(
            width: double.infinity,
            height: 45, // adjustable height
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.boxColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                print("SELECTED SERVICES BEFORE NAV: ${Get.find<ServiceController>().selectedServiceIds}");
                 showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => ArchitectPopup( projectId: projectController.projectId.value,),
                    );
              },
              child: Utils.textView(
                "Next",
                Get.height * 0.02,
                CustomColors.white,
                FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

  }
}
