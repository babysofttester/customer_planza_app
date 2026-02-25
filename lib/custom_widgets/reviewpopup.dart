

import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/reviewController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';


class ReviewPopup extends StatefulWidget {
  final String projectId;
  final String userId;
  final String userType;
  final String userName;
   // final String? avatar;
 // final String userImage;
  final String assignedDate;

  const ReviewPopup({
    super.key,
    required this.projectId,
    required this.userId,
    required this.userType,
    required this.userName,
  //  required this.userImage,
    required this.assignedDate, 
    //this.avatar, 
  });
  @override
  State<ReviewPopup> createState() => _ReviewPopupState();
}

class _ReviewPopupState extends State<ReviewPopup> with TickerProviderStateMixin{

  @override
void initState() {
  super.initState();

  Get.put(ReviewController(this));
}
 int rating = 0;
  final TextEditingController reviewCtrl = TextEditingController();

String getTodayDate() { 
  final now = DateTime.now();
  return "${now.day.toString().padLeft(2, '0')} "
      "${_monthName(now.month)} "
      "${now.year}";
}

String _monthName(int month) {
  const months = [
    "Jan","Feb","Mar","Apr","May","Jun",
    "Jul","Aug","Sep","Oct","Nov","Dec"
  ];
  return months[month - 1];
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
                  child: 
                  
          //        CircleAvatar(
          //   radius: 40,
          //   backgroundImage: widget.avatar != null && widget.avatar!.isNotEmpty
          //       ? NetworkImage(widget.avatar!)
          //       : null,
          //   child: widget.avatar == null || widget.avatar!.isEmpty
          //       ? const Icon(Icons.person, size: 40)
          //       : null,
          // ),
                  Image.asset(
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
  widget.userName,
  Get.width * 0.045,
  CustomColors.black,
  FontWeight.bold,
),
                     
//                       Utils.textViewStyle(
//   widget.assignedDate,
//   Get.width * 0.03,
//   CustomColors.black,
//   FontWeight.w400,
// ),

Utils.textViewStyle(
  getTodayDate(),
  Get.width * 0.03,
  CustomColors.black,
  FontWeight.w400,
),
                   
                    
                      const SizedBox(height: 6),


                    Row(
  children: List.generate(5, (index) {
    final isSelected = index < rating;

    return GestureDetector(
      onTap: () {
        setState(() {
          rating = index + 1;
        });
      },  
      child: Icon(
        isSelected ? Icons.star : Icons.star_border,
        color: isSelected
            ? const Color(0xFFF1BF47) 
            : Colors.grey.shade400,
        size: 28,
      ),
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
  if (reviewCtrl.text.trim().isEmpty) {
    Utils.showToast("Please write review"); 
    return;
  }

  Get.find<ReviewController>().submitReview(
  projectId: widget.projectId,
  userType: widget.userType,
  userId: widget.userId,
  rating: rating,
  comment: reviewCtrl.text.trim(),  
);
},
                    child:  
                     Utils.textView(
                 "Submit Review",
                  Get.width * 0.035,
                  CustomColors.white,
                  FontWeight.w500,
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
