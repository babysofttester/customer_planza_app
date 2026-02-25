
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/paymentHistoryController.dart';
import 'package:customer_app_planzaa/modal/choosePackageModel.dart' hide Result;
import 'package:customer_app_planzaa/modal/paymentModal.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:customer_app_planzaa/modal/paymentHistoryResponseModel.dart';



class PaymentCard extends StatefulWidget {
  // final PaymentItem item;
  final Result item;
  const PaymentCard({super.key, required this.item});

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> with TickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        //  border: Border.all(color: AppColors.primary),
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
                  'Project ID ',
                  Get.width * 0.04,
                  CustomColors.black,
                  FontWeight.w500,
                ),
                      Utils.textView(
                  widget.item.projectId?? '',
                  Get.width * 0.04,
                  CustomColors.black,
                  FontWeight.w600,
                ),
                
                  ],
                ),

                const SizedBox(height: 4),
                Row(
                  children: [
                      Utils.textView(
                   'Transaction ID: ',
                  Get.width * 0.04,
                  CustomColors.black,
                  FontWeight.w500,
                ),
                      Utils.textView(
                        widget.item.transactionId ?? '',
                  //widget.item.transactionId ?? '',
                  Get.width * 0.038,
                  CustomColors.boxColor,
                  FontWeight.w500,
                ),
                   
                  ],
                ),
                const SizedBox(height: 4),
                    Utils.textView(
                  '₹ ${widget.item.amount ?? ''}',
                  Get.width * 0.038,
                  CustomColors.black,
                  FontWeight.w600,
                ),
                

                const SizedBox(height: 4),
                 Utils.textViewStyle(
                   widget.item.paidDate ?? '',
                  Get.width * 0.038,
                  CustomColors.black,
                  FontWeight.w400,
                ),
               
                const SizedBox(height: 4),
                 Row(
                   children: [
                    Icon(Icons.cloud_outlined, size: 15,),
                    const SizedBox(width: 4),
                     Utils.textView(
                      widget.item.paymentMethod ?? '',
                      Get.width * 0.035,
                      CustomColors.black,
                      FontWeight.w400,
                                     ),
                   ],
                 ),
               

              ],
            ),
          ),


          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE9E9E9),
              borderRadius: BorderRadius.circular(5),
              // border: Border.all(color: statusColor),
            ),
            child: Text(
             'Download Invoice',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              //  color: statusColor,
              ),
            ),
          ), 
        ],
      ),
    );
  }
}
