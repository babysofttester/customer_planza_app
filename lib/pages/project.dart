

import 'package:customer_app_planzaa/controller/projectController.dart';
import 'package:customer_app_planzaa/pages/projectDetail.dart';
import 'package:customer_app_planzaa/pages/projectcards.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:planzaa_app/module/Project/Project/screen/projectcards.dart';

// import '../../../../widget/controller/bottomnavcontroller.dart';
// import '../../ProjectDetail/screen/projectDetail.dart';


class ProjectPage extends StatefulWidget {
  ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> with TickerProviderStateMixin{

  late final ProjectController projectController;
  // final ProjectController controller =
  // Get.put(ProjectController(this));

    @override
  void initState() {
    super.initState();

    projectController = Get.put(ProjectController(this));
  }


  @override
  Widget build(BuildContext context) {
   // controller.fetchProjects();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
         Obx(() {
          // if (controller.isLoading.value) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          if (projectController.projectList.isEmpty) {
            return const Center(child: Text("No Projects Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: projectController.projectList.length,
            itemBuilder: (context, index) {
              final project = projectController.projectList[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    Get.to(()=>ProjectDetail(item: project, projectId: project.id,));
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
