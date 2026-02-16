import 'package:customer_app_planzaa/common/appBar.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  String? selectedProject;
  String? selectedCategory;
  final TextEditingController descriptionController = TextEditingController();

  final List<String> projects = [
    'Project ID #223456',
    'Project ID #223457',
    'Project ID #223458',
  ];

  final List<String> categories = [
    'Payment Issue',
    'Design Issue',
    'Technical Support',
    'Design issue',
    'Service issue'
        'Account issue',
    'Other / General query',
  ];

  @override
  Widget build(BuildContext context) {
    // final BottomNavController nav = Get.find<BottomNavController>();

    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: const CustomAppBar(title: "Support"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PROJECT
               Utils.textView(
                      "Project",
                      Get.width * 0.04,
                      CustomColors.black,
                      FontWeight.normal,
                    ),
              // Text(
              //   "Project",
              //   // style: AppFonts.arcPop1()
              // ),
              const SizedBox(height: 8),
              _dropdown(
                hint: "Select Project",
                value: selectedProject,
                items: projects,
                onChanged: (val) {
                  setState(() => selectedProject = val);
                },
              ),

              const SizedBox(height: 20),

              /// CATEGORY
              Text(
                "Category",
                // style: AppFonts.arcPop1()
              ),
              const SizedBox(height: 8),
              _dropdown(
                hint: "Select Category",
                value: selectedCategory,
                items: categories,
                onChanged: (val) {
                  setState(() => selectedCategory = val);
                },
              ),

              const SizedBox(height: 20),

              /// DESCRIPTION
              Text(
                "Description",
                // style: AppFonts.arcPop1()
              ),
              const SizedBox(height: 8),
              _descriptionField(),

              const SizedBox(height: 30),

              /// SUBMIT BUTTON
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
                    // nav.changeIndex(0);
                  },
                  child: const Text(
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
      ),
    );
  }

  /// DROPDOWN FIELD
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
          hint: Text(
            hint,
            // style: AppFonts.arcPop1(color: Colors.grey),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    // style: AppFonts.arcPop1()
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  /// DESCRIPTION FIELD
  Widget _descriptionField() {
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
        controller: descriptionController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: "Message",
          // hintStyle: AppFonts.arcPop1(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1F3C88)),
          ),
        ),
      ),
    );
  }
}
