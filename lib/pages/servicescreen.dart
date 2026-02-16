import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/servicecontroller.dart';
import 'package:customer_app_planzaa/pages/servicecard.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';



class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            Expanded(
              child: Obx(() {
                return GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 4,
                    childAspectRatio: 4.5,
                  ),
                  itemCount: serviceController.services.length,
                  itemBuilder: (context, index) {
                    return ServiceCard(
                      item: serviceController.services[index],
                      index: index,
                      compact: true,
                    );
                  },
                );
              }),
            ),

            SizedBox(height: Get.height * 0.018),

            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:CustomColors.boxColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  // Get.find<BottomNavController>().openInner( 
                  // page: AddProject(), 
                  // title: "Add Project", 
                  // );
                },
                child: 
                 Utils.textView(
                            "Nextss",
                            Get.height * 0.018,
                            CustomColors.white,
                            FontWeight.normal,
                          ), 
                // const Text(
                //   "Next",
                //   style: TextStyle(
                //       fontSize: 15, color: Colors.white),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
