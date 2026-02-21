

import 'package:customer_app_planzaa/controller/addProjectController.dart';
import 'package:customer_app_planzaa/controller/servicecontroller.dart';
import 'package:customer_app_planzaa/custom_widgets/searchabledropdown.dart';
import 'package:customer_app_planzaa/pages/addproject.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


class ArchitectPopup extends StatefulWidget {
  final int projectId;
  const ArchitectPopup({super.key, required this.projectId });

  @override
  State<ArchitectPopup> createState() => _ArchitectPopupState();
}

class _ArchitectPopupState extends State<ArchitectPopup>  with TickerProviderStateMixin  {
  String? selectedState;
  String? selectedDistrict;
 
 late final AddProjectController controller;
  // final AddProjectController controller =
  //   Get.put(AddProjectController());


@override
void initState() {
  super.initState();
  controller = Get.put(AddProjectController(this));

  controller.fetchStates();   // 🔥 THIS IS MISSING
}


  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TITLE + CLOSE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Architect’s",
                 
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// STATE
            Text("State"),
            const SizedBox(height: 6),

            // _dropdownField(
            //   // hint: "Select State",
            //   // items: ["Delhi", "Maharashtra", "Karnataka"],
            //   // value: selectedState,
            //   // onChanged: (val) {
            //   //   setState(() => selectedState = val);
            //   // },
            //   hint: "Select State",
            //   items: controller.states,
            //   value: controller.selectedState.value,
            //   onChanged: (val) {
            //   controller.selectedState.value = val;
            //   controller.fetchCities(val!);
            // },
            // ),
           Obx(() => SearchableDropdown(
      hint: "Select State",
      items: controller.states,
      value: controller.selectedState.value,
      onSelected: (val) {
        controller.selectedState.value = val;
        controller.fetchCities(val);
      },
)),



            const SizedBox(height: 12),

            /// DISTRICT
            Text("District",),
            const SizedBox(height: 6),

            // _dropdownField(
            //   // hint: "Select District",
            //   // items: ["Mumbai", "Pune", "Nagpur"],
            //   // value: selectedDistrict,
            //   // onChanged: (val) {
            //   //   setState(() => selectedDistrict = val);
            //   // },
            //   hint: "Select District",
            //   items: controller.cities,
            //   value: controller.selectedCity.value,
            //   onChanged: (val) {
            //   controller.selectedCity.value = val;
            // },
            // ),

          Obx(() => SearchableDropdown(
      hint: "Select District",
      items: controller.cities,
      value: controller.selectedCity.value,
      onSelected: (val) {
        controller.selectedCity.value = val;
      },
)),


            const SizedBox(height: 20),

            /// NEXT BUTTON
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3C88),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                      if (Get.find<ServiceController>().selectedServiceIds.isEmpty) {
      Get.snackbar("Error", "Please select at least one service");
      return;
    }
                 
 Get.to(() => AddProject(
      projectId: widget.projectId,
      serviceIds: Get.find<ServiceController>().selectedServiceIds.toList(),
    ));
               

                },

                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ), 
      ),
    );
  }

  /// DROPDOWN FIELD
  Widget _dropdownField({
    required String hint,
    required List<String> items,
    String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down),
      decoration: InputDecoration(
        hintText: hint,
        // hintStyle: AppFonts.arcPop2(),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1F3C88)),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item, ),
        ),
      )
          .toList(),
      onChanged: onChanged,
      dropdownColor: Colors.white,
    );
  }
}
