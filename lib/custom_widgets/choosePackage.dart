

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../controller/bottomnavcontroller.dart';

class ChoosePackage extends StatefulWidget {
  final int designerId; // ✅ must be declared
  const ChoosePackage({super.key, required this.designerId});

  @override
  State<ChoosePackage> createState() => _ChoosePackageState();
}

class _ChoosePackageState extends State<ChoosePackage> {
  int selected = 1;

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
                Text(
                  "Choose Package",
                
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 20),
                )
              ],
            ),

            SizedBox(height: Get.height * 0.009),


            Row(
              children: [
                Transform.scale(
                  scale: 1,
                  child: Radio<int>(
                    value: 0,
                    groupValue: selected,
                    // activeColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    onChanged: (val) {
                      setState(() => selected = val!);
                    },
                  ),
                ),

                const SizedBox(width: 6),

                Text(
                  "Designer Only",
                  // style: AppFonts.packageSubHeading().copyWith(
                  //   color: selected == 0
                  //       ? const Color(0xFF1F3C88)
                  //       : Colors.black,
                  // ),
                ),
              ],
            ),




            SizedBox(height: Get.height * 0.009),


            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected == 1
                      ? const Color(0xFF1F3C88)
                      : Colors.transparent,
                ),
              ),
             child:  Container(
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
                              setState(() => selected = val!);
                            },
                          ),
                        ),

                        const SizedBox(width: 6),

                        Expanded(
                          child: Text(
                            "Designer + Surveyor",
                            // style: AppFonts.packageSubHeading2(),
                          ),
                        ),

                        Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            // color: AppColors.secondary,
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
                        // style: AppFonts.packageSubContent(),
                      ),
                    ),
                  ],
                ),
              ),

            ),

            const SizedBox(height: 20),


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
                  Navigator.pop(context);

                  // Get.find<BottomNavController>().openInner(
                  //   page: PaymentScreen(),
                  //   title: "Payment",
                  // );

                },
                child: Text(
                  "Continue to Payment",
                    // style: AppFonts.bookButton()
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
