

import 'package:customer_app_planzaa/modal/projectmodal.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
// import 'package:planzaa_app/modal/projectmodal.dart';

// import '../../../../utils/app_fonts.dart';

class ProjectCards extends StatelessWidget {
  final ProjectsItem item;

  const ProjectCards({
    super.key,
    required this.item,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF53AC40);

      case 'payment_pending':
      case 'pending':
        return const Color(0xFF6F67C5);

      case 'in_progress':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }


  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.status);

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
                      // style: AppFonts.proHead(),
                    ),
                    Text(
                      item.title,
                      // style: AppFonts.proHead(),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                SizedBox(
                  width: Get.width * 0.6,
                  child: Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // style: AppFonts.prosubHead(),
                  ),
                ),



              ],
            ),
          ),


          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(5),
             // border: Border.all(color: statusColor),
            ),
            child: Text(
              item.status.replaceAll('_', ' ').capitalizeFirst ?? '',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),

          ),
        ],
      ),
    );
  }

}

