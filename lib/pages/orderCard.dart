import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/reviewController.dart';
import 'package:customer_app_planzaa/custom_widgets/reviewpopup.dart';
import 'package:customer_app_planzaa/modal/orderModal.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart' show Inst;
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:customer_app_planzaa/modal/choosePackageModel.dart' hide Result;
import 'package:customer_app_planzaa/modal/orderHistoryResponseModel.dart';


class OrderCard extends StatefulWidget {
  final Result item;
   OrderCard({super.key, required this.item});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> with TickerProviderStateMixin{
late ReviewController controller;

@override
void initState() {
  super.initState();

  controller = Get.put(ReviewController(this));
}

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
    final statusColor = statusTextColor(widget.item.projectStatus);
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
                  '${widget.item.bookingNo}',
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
                 widget.item.userName ?? '',
                  Get.width * 0.038,
                  CustomColors.black,
                  FontWeight.w600,
                ),//textViewStyle
                    
                  Utils.textViewStyle(
             widget.item.assignedAt ?? '',
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
                   widget.item.projectStatus ?? '',
                  Get.width * 0.038,
                  statusColor,
                  FontWeight.w600,
                ),
               
              ),
              const SizedBox(height: 8),
                             Utils.textView(
                 '₹ ${widget.item.amount ?? "0"}',
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
               onPressed: () async {
  // await controller.getOrderDetail(widget.item.projectId.toString());

  final designer =
      controller.orderDetailModel?.data?.result?.designer;

  showDialog(
    context: context,
    barrierDismissible: true, 
    builder: (_) => ReviewPopup(
      projectId: widget.item.projectId.toString(),
      userId: widget.item.userId.toString(),
      userType: "designer",
      userName: designer?.name ?? widget.item.userName ?? "",
     // avatar: designer?.avatar ?? "", 
      assignedDate: widget.item.assignedAt ?? "",
    ),
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