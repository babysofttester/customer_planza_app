import 'package:customer_app_planzaa/custom_widgets/reviewpopup.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart' show Inst;
import '../../../../modal/orderModal.dart';
// import '../../../../utils/app_fonts.dart';
// import '../../../../widget/controller/bottomnavcontroller.dart';

// import '../../../../widget/screen/reviewpopup.dart';
// import '../../Order Detail/screen/order_detail.dart';


class OrderCard extends StatelessWidget {
  final OrderItem item;
  const OrderCard({super.key, required this.item});

  Color statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF5BAF47); // green
      case 'incompleted':
        return const Color(0xFFF4A546); // orange
      case 'pending':
        return const Color(0xFF6F67C5); // purple
      default:
        return Colors.grey;
    }
  }


  @override
  Widget build(BuildContext context) {
    final statusColor = statusTextColor(item.status);
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
                      'Order ',
                      // style: AppFonts.proHead2(),
                    ),
                    Text(
                      item.orderId,
                      // style: AppFonts.desHead(),
                    ),
                  ],
                ),

                const SizedBox(height: 4),


                    Text(
                      item.name,
                      // style: AppFonts.packageSubHeading4(),
                    ),


                const SizedBox(height: 4),
                Text(
                  item.date,
                  // style: AppFonts.packageSubHeading3(size: 11).copyWith(
                  //   fontStyle: FontStyle.italic,

                  // ),
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
                  // border: Border.all(color: statusColor),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '₹ ${item.amount}',
                // style: AppFonts.packageSubHeading2(),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3C88),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  minimumSize: const Size(
                    0,
                    30,
                  ),
                  tapTargetSize: MaterialTapTargetSize
                      .shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => const ReviewPopup(),
                  );

                },

                child: Text(
                  "Leave a Review",
                  // style: AppFonts.button(
                  //   height: 1.0,
                  // ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

