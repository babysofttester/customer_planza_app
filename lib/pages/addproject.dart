import 'dart:io';

import 'dart:ui';
import 'package:customer_app_planzaa/common/appBar.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/custom_widgets/map_picker.dart';
import 'package:customer_app_planzaa/custom_widgets/searchabledropdown.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:reorderables/reorderables.dart';

import '../controller/addProjectController.dart';

class AddProject extends StatefulWidget {
   final int projectId;
     final List<int> serviceIds;
  const AddProject({super.key, required this.projectId, required this.serviceIds,});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> with TickerProviderStateMixin {
  // String? selectedState;
  // String? selectedDistrict;

  int floor = 0;
  final TextEditingController floorController = TextEditingController(
    text: "0",
  );

  List<XFile> images = [];

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                controller.pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                controller.pickFromGallery();
              },
            ),
          ],
        );
      },
    );
  }

  void _openSearchBottomSheet({
    required String title,
    required List<String> items,
    required Function(String) onSelected,
  }) {
    final searchController = TextEditingController();
    final RxList<String> filteredList = items.obs;

    Get.bottomSheet(
      Container(
        height: Get.height * 0.65,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              // style: AppFonts.arcPop1()
            ),
            const SizedBox(height: 12),

            // 🔍 Search Field
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                filteredList.assignAll(
                  items
                      .where(
                        (e) => e.toLowerCase().contains(value.toLowerCase()),
                      )
                      .toList(),
                );
              },
            ),

            const SizedBox(height: 12),

            // 📜 List
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return ListTile(
                      title: Text(
                        item,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        onSelected(item);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  //final AddProjectController controller;
  late AddProjectController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(AddProjectController(this));
    controller.fetchStates();
      // 👇 AUTO SELECT SERVICES
  controller.selectedServiceIds
      .assignAll(widget.serviceIds);

  print("AUTO LOADED SERVICES: ${widget.serviceIds}");
  print("SERVICES: ${controller.selectedServiceIds.toList()}");

  
  }

  final TextEditingController lengthController = TextEditingController();
  final TextEditingController breadthController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  //AddProjectController controller = Get.put(AddProjectController());

  @override
  Widget build(BuildContext context) {
     //LatLng? selectedLatLng;

    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: const CustomAppBar(title: "Add Project"),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Utils.textView(
                      'Plot Size / Project',
                      Get.width * 0.045,
                      CustomColors.black,
                      FontWeight.bold,
                    ),
                    
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 18,
                                child: Utils.textView(
                                  "State",
                                  Get.width * 0.038,
                                  CustomColors.black,
                                  FontWeight.w500,
                                ),
                              
                              ),
                              const SizedBox(height: 2),

                              Obx(
                                () => SearchableDropdown(
                                  hint: "Select State",
                                  items: controller.states,
                                  value: controller.selectedState.value,
                                  onSelected: (val) {
                                    controller.selectedState.value = val;
                                    controller.fetchCities(val);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 18, 
                                child: Utils.textView(
                                  "District",
                                  Get.width * 0.038,
                                  CustomColors.black,
                                  FontWeight.w500,
                                ),
                            
                              ),

                              const SizedBox(height: 2),

                              Obx(
                                () => SearchableDropdown(
                                  hint: "Select District",
                                  items: controller.cities,
                                  value: controller.selectedCity.value,
                                  onSelected: (val) {
                                    controller.selectedCity.value = val;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.03),

                    //lat long
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (controller.selectedState.value == null ||
                                  controller.selectedCity.value == null) {
                                Get.snackbar(
                                  "Error",
                                  "Please select state and district first",
                                );
                                return;
                              }

                              String address =
                                  "${controller.selectedCity.value}, ${controller.selectedState.value}, India";

                              List<Location> locations =
                                  await locationFromAddress(address);

                              if (locations.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Unable to find district location",
                                );
                                return;
                              }

                              LatLng districtLatLng = LatLng(
                                locations.first.latitude,
                                locations.first.longitude,
                              );

                              final LatLng? result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MapPickerPage(
                                    initialLocation: districtLatLng,
                                  ),
                                ),
                              );

                              if (result != null) {
                                setState(() {
                                  latitudeController.text = result.latitude
                                      .toString();
                                  longitudeController.text = result.longitude
                                      .toString();
                                });
                              }
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1F3C88),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_location_alt_sharp,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: Get.width * 0.02),
                                Utils.textView(
                                  "Select Location",
                                  Get.height * 0.02,
                                  CustomColors.white,
                                  FontWeight.bold,
                                ),
                            
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: Get.height * 0.01),
                        Row(
                          children: [
                            // Icon(Icons.share_location_rounded),
                            // const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Utils.textView(
                                  "Latitude",
                                  Get.width * 0.038,
                                  CustomColors.black,
                                  FontWeight.w500,
                                ),
                                  // Text(
                                  //   "Latitude",
                                  //   // style: AppFonts.arcPop1()
                                  // ),
                                  const SizedBox(height: 2),
                                  GestureDetector(
                                    onTap: () {},
                                    child: _textField(
                                      hint: "Latitude",
                                      controller: latitudeController,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Utils.textView(
                                  "Longitude",
                                  Get.width * 0.038,
                                  CustomColors.black,
                                  FontWeight.w500,
                                ),
                                  // Text(
                                  //   "Longitude",
                                  //   // style: AppFonts.arcPop1()
                                  // ),
                                  const SizedBox(height: 2),
                                  GestureDetector(
                                    onTap: () {},
                                    child: _textField(
                                      hint: "Longitude",
                                      controller: longitudeController,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.02),

                    //length & breadth 
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Utils.textView(
                                  "Length",
                                  Get.width * 0.038,
                                  CustomColors.black,
                                  FontWeight.w500,
                                ),
                              // Text(
                              //   "Length",
                              //   // style: AppFonts.arcPop1()
                              // ),
                              const SizedBox(height: 2),
                              _textField(
                                hint: "0.00",
                                controller: lengthController,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Utils.textView(
                                  "Breadth",
                                  Get.width * 0.038,
                                  CustomColors.black,
                                  FontWeight.w500,
                                ),
                              // Text(
                              //   "Breadth",
                              //   // style: AppFonts.arcPop1()
                              // ),
                              const SizedBox(height: 2),
                              _textField(
                                hint: "0.00",
                                controller: breadthController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Get.height * 0.02),

                    //floor
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Utils.textView(
                                  "Floor",
                                  Get.width * 0.038,
                                  CustomColors.black,
                                  FontWeight.w500,
                                ),
                        // Text(
                        //   "Floor",
                        //   // style: AppFonts.arcPop1()
                        // ),
                        const SizedBox(height: 2),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _stepperButton(
                              icon: Icons.add,
                              onTap: controller.incrementFloor,
                            ),

                            const SizedBox(width: 10),

                            SizedBox(
                              width: 90,

                              child: TextField(
                                controller: controller.floorController,
                                readOnly: true,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF1F3C88),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            _stepperButton(
                              icon: Icons.remove,
                              onTap: controller.decrementFloor,
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: Get.height * 0.03),

                    Divider(),
                    SizedBox(height: Get.height * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Utils.textView(
                                  "Add Images",
                                  Get.width * 0.038,
                                  CustomColors.black,
                                  FontWeight.w500,
                                ),
                      
                        const SizedBox(height: 16),

                        _addImageCard(context),
                        SizedBox(height: Get.height * 0.02),
                        _imageGrid(),
                      ],
                    ),

                    SizedBox(height: Get.height * 0.03),

                    //lat long
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        // onPressed: () {
                        //   Get.find<BottomNavController>().openInner(
                        //     page: DesignerScreen(),
                        //     title: "Designer",
                        //   );
                        //
                        // },
                        onPressed: () {
                          if (controller.selectedState.value == null ||
                              controller.selectedCity.value == null) {
                            Get.snackbar(
                              "Error",
                              "Please select state and district",
                            );
                            return;
                          }

                          if (lengthController.text.isEmpty ||
                              breadthController.text.isEmpty ||
                              latitudeController.text.isEmpty ||
                              longitudeController.text.isEmpty) {
                            Get.snackbar("Error", "Please fill all fields");
                            return;
                          }

                          controller.addProject(
                            controller.selectedState.value!,
                            controller.selectedCity.value!,
                            lengthController.text,
                            breadthController.text,
                            latitudeController.text,
                            longitudeController.text,
                            
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F3C88),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String hint,
    required List<String> items,
    TextStyle? style,
    String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down),
      style: style,
      decoration: InputDecoration(
        hintText: hint,
        // hintStyle: AppFonts.arcPop1(),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1F3C88)),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, 
            // style: AppFonts.arcPop1(),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      dropdownColor: Colors.white,
    );
  }

  Widget _searchableDropdown({
    required String hint,
    required List<String> items,
    String? value,
    required Function(String) onSelected,
  }) {
    return InkWell(
      onTap: () {
        _openSearchBottomSheet(
          title: hint,
          items: items,
          onSelected: onSelected,
        );
      },
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: hint,
             hintStyle: TextStyle(
  color: CustomColors.textGrey,
  fontSize: 15
),
          // hintStyle: AppFonts.arcPop1(),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          suffixIcon: const Icon(Icons.keyboard_arrow_down),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        child: Text(
          value ?? hint,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
             style: TextStyle(
  color: CustomColors.textGrey,
  fontSize: 15
),
          // style: AppFonts.arcPop1(),
        ),
      ),
    );
  }

  Widget _textField({
    required String hint,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
     hintStyle: TextStyle(
  color: CustomColors.textGrey,
  fontSize: 15
),


        // hintStyle: AppFonts.arcPop1(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1F3C88)),
        ),
      ),
      cursorColor: Color(0xFF1F3C88),
    );
  }

  Widget _stepperButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 45,
        width: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A8A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _addImageCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceSheet(context),
      child: DottedBorder(
        options: RectDottedBorderOptions(
          dashPattern: const [6, 4],

          // radius: const Radius.circular(12),
          color: Colors.grey,
          strokeWidth: 1,
          // padding: const EdgeInsets.symmetric(vertical: 28),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F6F3),
            // borderRadius: BorderRadius.circular(1),
          ),
          child: Column(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF1E3A8A)),
                ),
                child: const Icon(Icons.add, color: const Color(0xFF1E3A8A)),
              ),
              const SizedBox(height: 12),
              const Text(
                "Add Photo",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                "Upload relevant work images",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageGrid() {
    return Obx(() {
      if (controller.images.isEmpty) {
        return const SizedBox();
      }

      return ReorderableWrap(
        spacing: 8,
        runSpacing: 8,
        onReorder: controller.reorderImages,
        children: List.generate(controller.images.length, (index) {
          final image = controller.images[index];
          return Stack(
            key: ValueKey(image.path),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(image.path),
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () => controller.removeImage(index),
                  child: const CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),
      );
    });
  }
}
