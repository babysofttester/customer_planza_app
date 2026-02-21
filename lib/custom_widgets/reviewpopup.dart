

import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../controller/bottomnavcontroller.dart';

class ReviewPopup extends StatefulWidget {
  const ReviewPopup({super.key});

  @override
  State<ReviewPopup> createState() => _ReviewPopupState();
}

class _ReviewPopupState extends State<ReviewPopup> {
  int rating = 5;
  final TextEditingController reviewCtrl = TextEditingController();

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
                   Utils.textView(
                 "Leave a Review",
                  Get.width * 0.035,
                  CustomColors.black,
                  FontWeight.w500,
                ),
                // Text("Leave a Review",
                //     // style: AppFonts.packageHeading(size: 15)
                //     ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),

            SizedBox(height: Get.height * 0.03),


            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/bgImage.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),


                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Utils.textView(
                 "Adam Collins",
                  Get.width * 0.045,
                  CustomColors.black,
                  FontWeight.bold,
                ),
                      // Text("Adam Collins",
                      //     // style: AppFonts.desHead()
                      //     ),

                       Utils.textViewStyle(
             "Jan 02, 2026",
                  Get.width * 0.03,
                  CustomColors.black,
                  FontWeight.w400,
                ),
                      const SizedBox(height: 2),
                      // Text(
                      //   "Jan 02, 2026",
                      //   // style: AppFonts.packageSubContent().copyWith(
                      //   //   fontStyle: FontStyle.italic,
                      //   // ),
                      // ),
                      const SizedBox(height: 6),


                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xFFF4B400),
                            size: 20,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),


            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: reviewCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Write your review...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3AAFA9),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: 
                     Utils.textView(
                 "Cancel",
                  Get.width * 0.035,
                  CustomColors.white,
                  FontWeight.w500,
                ),
                   
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F3C88),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // submit logic
                      Navigator.pop(context);
                    },
                    child:  Text(
                      "Submit Review",
                        // style: AppFonts.bookButton(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
