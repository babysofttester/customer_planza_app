// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:planzaa_app/boldScaffold.dart';
// import 'package:planzaa_app/modal/designnermodal.dart';
// import 'package:planzaa_app/module/Designer/screen/designerCard.dart';
//
// import '../../../utils/app_fonts.dart';
// import '../../../widget/controller/bottomnavcontroller.dart';
// import '../../../widget/screen/bottomnavigation.dart';
// import '../../Drawer/screen/drawer.dart';
// import '../../Project/AddProject/screen/addproject.dart';
// import '../Designer Services/screen/designerServices.dart';
//
// class DesignerScreen extends StatefulWidget {
//   const DesignerScreen({super.key});
//
//   @override
//   State<DesignerScreen> createState() => _DesignerScreenState();
// }
//
// class _DesignerScreenState extends State<DesignerScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: ListView.builder(
//           padding: const EdgeInsets.all(8),
//           itemCount: designers.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 8),
//               child: GestureDetector(
//                 onTap: () {
//
//                 },
//                 child: DesignerCard(
//                   item: designers[index],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:customer_app_planzaa/controller/dsignerController.dart';
import 'package:customer_app_planzaa/pages/designerCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:http/http.dart' as http;

class DesignerScreen extends StatefulWidget {
  const DesignerScreen({super.key});

  @override
  State<DesignerScreen> createState() => _DesignerScreenState();
}

class _DesignerScreenState extends State<DesignerScreen> {

  final DesignerController controller =
  Get.put(DesignerController());
  @override
  void initState() {
    super.initState();

    final controller = Get.find<DesignerController>();

    if (controller.state != null && controller.district != null) {
      controller.fetchDesigners();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<DesignerController>(
          init: DesignerController(),   // VERY IMPORTANT
          builder: (controller) {
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.designers.isEmpty) {
              return const Center(
                child: Text("No Designers Found"),
              );
            }
        
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: controller.designers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DesignerCard(
                    item: controller.designers[index],
                    currencySymbol: controller.currencySymbol,
                  ),
                );
              },
            );
          },
        ),
      ),

    );
  }
}
