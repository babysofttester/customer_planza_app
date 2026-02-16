
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../modal/paymentModal.dart';
// import '../../../../utils/app_fonts.dart';

class PaymentCard extends StatelessWidget {
  final PaymentItem item;
  const PaymentCard({super.key, required this.item});

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
                    Text(
                      'Project ID ',
                      // style: AppFonts.proHead2(),
                    ),
                    Text(
                      item.projectId,
                      // style: AppFonts.desHead(),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Transaction ID: ',
                      // style: AppFonts.packageSubHeading(),
                    ),
                    Text(
                      item.transId,
                      // style: AppFonts.packageSubHeading2(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '₹ ${item.amount}',
                  // style: AppFonts.packageSubHeading4(),
                ),

                const SizedBox(height: 4),
                Text(
                  item.dateTime,
                  // style: AppFonts.packageSubHeading3(),
                ),
                const SizedBox(height: 4),
                Text(
                  item.payMethod,
                  // style: AppFonts.packageSubHeading3(size: 11),
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
