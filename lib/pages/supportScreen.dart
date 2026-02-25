import 'package:customer_app_planzaa/common/appBar.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/supportController.dart';
import 'package:customer_app_planzaa/custom_widgets/searchabledropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with TickerProviderStateMixin {

  late SupportController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SupportController(this));
  }

  final List<String> categories = [
    'Payment Issue',
    'Design Issue',
    'Technical Support',
    'Service issue',
    'Account issue',
    'Other / General query',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: const CustomAppBar(title: "Support"),
      body: GetBuilder<SupportController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
Utils.textView(
  "Project",
  Get.width * 0.04,
  CustomColors.black,
  FontWeight.normal,
),

const SizedBox(height: 8),

 SearchableDropdown(
      hint: "Select Project",
      value: controller.selectedProjectId.isEmpty
          ? null
          : controller.projectList
      .firstWhere(
        (p) => p.id == controller.selectedProjectId, 
        orElse: () => controller.projectList.first,
      )
      .number,
      items: controller.projectList
          .map((project) => project.number ?? "")
          .toList(),
      onSelected: (selectedNumber) {
        final selectedProject = controller.projectList.firstWhere(
          (p) => p.number == selectedNumber,
        );
    
        controller.selectedProjectId = selectedProject.id ?? "";
        controller.update();
      },
    ),            

       const SizedBox(height: 20),
                  Utils.textView(
                    "Category",
                    Get.width * 0.04,
                    CustomColors.black,
                    FontWeight.normal,
                  ),

                  const SizedBox(height: 8),

                 SearchableDropdown(
  hint: "Select Category",
  value: controller.selectedCategory.isEmpty
      ? null
      : controller.selectedCategory,
  items: categories,
  onSelected: (val) {
    controller.selectedCategory = val;
    controller.update();
  },
),

                  const SizedBox(height: 20),

                 
                  Utils.textView(
                    "Description",
                    Get.width * 0.04,
                    CustomColors.black,
                    FontWeight.normal,
                  ),

                  const SizedBox(height: 8),

                  _descriptionField(controller),

                  const SizedBox(height: 30),

                 
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F3C88),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                              controller.submitSupport();
                            },
                      child:  const Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// DROPDOWN
  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// DESCRIPTION FIELD
  Widget _descriptionField(SupportController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller.descriptionController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: "Message",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}