import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/choosePackageController.dart';
import 'package:customer_app_planzaa/controller/designerDetailController.dart';
import 'package:customer_app_planzaa/modal/designnermodal.dart';
import 'package:customer_app_planzaa/modal/project_detail_response_model.dart';
import 'package:customer_app_planzaa/pages/paymentScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../controller/bottomnavcontroller.dart';

class ChoosePackage extends StatefulWidget {
 // final int designerId;
    final int projectId;
    final DesignerItem designer; 
    // final Map<String, dynamic> service;
    final List<Service> services;
  const ChoosePackage({super.key, required this.projectId, required this.designer, required this.services});

  @override
  State<ChoosePackage> createState() => _ChoosePackageState();
}

class _ChoosePackageState extends State<ChoosePackage> with TickerProviderStateMixin {
  int selected = 1;
  late ChoosePackageController packageController;
  late List<Service> servicesToUse;

  @override
  void initState() {
    super.initState();

    packageController = Get.put(ChoosePackageController(this));

   
    servicesToUse = widget.services;
    if (servicesToUse.isEmpty && widget.designer.services!= null && widget.designer.services!.isNotEmpty) {
      servicesToUse = widget.designer.services;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Choose Package"),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),

            SizedBox(height: Get.height * 0.009),

            // Radio buttons
            Row(
              children: [
                Transform.scale(
                  scale: 1,
                  child: Radio<int>(
                    value: 0,
                    groupValue: selected,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    onChanged: (val) {
                      if (val != null) setState(() => selected = val);
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Utils.textView(
                  "Designer Only",
                  Get.height * 0.018,
                  CustomColors.black,
                  FontWeight.normal,
                ),
              ],
            ),

            SizedBox(height: Get.height * 0.009),

            // Designer + Surveyor container
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected == 1 ? const Color(0xFF1F3C88) : Colors.transparent,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1,
                          child: Radio<int>(
                            value: 1,
                            groupValue: selected,
                            activeColor: const Color(0xFF1F3C88),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            onChanged: (val) {
                              if (val != null) setState(() => selected = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Utils.textView(
                            "Designer + Surveyor",
                            Get.height * 0.018,
                            CustomColors.black,
                            FontWeight.normal,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: CustomColors.orange,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Recommended",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 36),
                      child: Text(
                        "A surveyor will visit your site within the next 24 hours "
                        "to collect all required measurements and details for an accurate design.",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3C88),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (servicesToUse.isEmpty) {
                    Utils.showToast("No services available");
                    return;
                  }

                  final service = servicesToUse.first;

                  String packageType = selected == 0 ? "designer" : "both";
                  String jobTypeText = selected == 0 ? "Designer" : "Both";

                  packageController.choosePackage(
                    projectId: widget.projectId,
                    packageType: packageType,
                    designer: widget.designer,
                    jobTypeText: packageType,
                    serviceId: service.id ?? 0,
                    serviceName: service.serviceName ?? '',
                    price: service.price?.toString() ?? '0',
                  );
                },
                child: Utils.textView(
                  "Continue to Payment",
                  Get.height * 0.02,
                  CustomColors.white,
                  FontWeight.bold,
                ),
              ),
            ),
          ],
        ), 
      ),
    );
  }
}