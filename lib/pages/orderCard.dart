import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/custom_widgets/reviewpopup.dart';
import 'package:customer_app_planzaa/modal/orderModal.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart' show Inst;
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:customer_app_planzaa/modal/choosePackageModel.dart' hide Result;
import 'package:customer_app_planzaa/modal/orderHistoryResponseModel.dart';


class OrderCard extends StatelessWidget {
  final Result item;
  const OrderCard({super.key, required this.item});

  Color statusTextColor(String? status) {
    final s = status?.toLowerCase().trim() ?? '';
    switch (s) {
      case 'completed':
        return const Color(0xFF53AC40);
      case 'payment pending':
        return const Color.fromARGB(255, 56, 41, 219); 
      case 'progress':
        return Colors.orange;
      case 'review pending':
        return Colors.blue;
      case 'incompleted':
        return Colors.red;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.black45;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = statusTextColor(item.projectStatus);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.19),
            blurRadius: 12,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                                         Utils.textView(
                  'Order ',
                  Get.width * 0.04,
                  CustomColors.black,
                  FontWeight.w500,
                ),
                      Utils.textView(
                  '${item.bookingNo}',
                  Get.width * 0.04,
                  CustomColors.black,
                  FontWeight.w600,
                ),
                    // Text('Order ', style: TextStyle(fontWeight: FontWeight.w500)),
                    // Text('${item.bookingNo}', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                    Utils.textView(
                 item.userName ?? '',
                  Get.width * 0.038,
                  CustomColors.black,
                  FontWeight.w600,
                ),//textViewStyle
                    
                  Utils.textViewStyle(
             item.assignedAt ?? '',
                  Get.width * 0.03,
                  CustomColors.black,
                  FontWeight.w400,
                ),
               
              ],
            ), 
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: 
                 Utils.textView(
                   item.projectStatus ?? '',
                  Get.width * 0.038,
                  statusColor,
                  FontWeight.w600,
                ),
               
              ),
              const SizedBox(height: 8),
                             Utils.textView(
                 '₹ ${item.amount ?? "0"}',
                  Get.width * 0.038,
                  CustomColors.boxColor,
                  FontWeight.w600,
                ),
              
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3C88),
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  minimumSize: const Size(0, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => const ReviewPopup(),
                  );
                },
                child: 
                  Utils.textView(
                 "Leave a Review",
                  Get.width * 0.035,
                  CustomColors.white,
                  FontWeight.w500,
                ),
                
              ),
            ],
          ),
        ],
      ),
    );
  }
}