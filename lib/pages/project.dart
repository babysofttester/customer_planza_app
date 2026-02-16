

import 'package:customer_app_planzaa/pages/projectcards.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:planzaa_app/module/Project/Project/screen/projectcards.dart';

// import '../../../../widget/controller/bottomnavcontroller.dart';
// import '../../ProjectDetail/screen/projectDetail.dart';
import '../controller/projectController.dart';

class ProjectPage extends StatelessWidget {
  ProjectPage({super.key});

  final ProjectController controller =
  Get.put(ProjectController());

  @override
  Widget build(BuildContext context) {
   // controller.fetchProjects();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.projectList.isEmpty) {
            return const Center(child: Text("No Projects Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.projectList.length,
            itemBuilder: (context, index) {
              final project = controller.projectList[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    // Get.find<BottomNavController>().openInner(
                    //   page: ProjectDetail(item: project),
                    //   title: "Project Details",
                    // );
                  },
                  child: ProjectCards(item: project),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
