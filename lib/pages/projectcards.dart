

import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/modal/projectmodal.dart';
import 'package:customer_app_planzaa/pages/addproject.dart';
import 'package:customer_app_planzaa/pages/projectDetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
// import 'package:planzaa_app/modal/projectmodal.dart';

// import '../../../../utils/app_fonts.dart';

class ProjectCards extends StatefulWidget {
  final ProjectsItem item;

  const ProjectCards({
    super.key,
    required this.item,
  });

  @override
  State<ProjectCards> createState() => _ProjectCardsState();
}

class _ProjectCardsState extends State<ProjectCards> {
Color _statusColor(String status) {
  final s = status.toLowerCase().trim();

  switch (s) {
    case 'completed':
      return const Color(0xFF53AC40); // Green
 
    case 'payment pending':
      return const Color.fromARGB(255, 56, 41, 219); // Purple

    case 'progress':
      return Colors.orange; // Orange

    case 'review pending':
      return Colors.blue; // Blue

    case 'incompleted':
    // case 'incompleted': // handle typo from server
      return Colors.red; // Red

    case 'draft':
      return Colors.grey; // Grey
 
    default:
      return Colors.black45; // fallback
  }
}

//payment pending, progress, review pending, completed, incompletd, draft
  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(widget.item.status);
    final status = widget.item.status.toLowerCase().trim();
 


    return InkWell(
    onTap: () {
      if (status == 'draft') {
       
        Get.to(() => AddProject(
              projectId: widget.item.id, 
               serviceIds: widget.item.selectedServiceIds,
            ));
      } else {
        
        Get.to(() => ProjectDetail(
              projectId: widget.item.id, item: widget.item,
            ));
      }
    },
      
      
      child: Container(
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

      /// LEFT CONTENT
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Utils.textView(
                  'Project ID ${widget.item.title}',
                  Get.width * 0.035,
                  CustomColors.black,
                  FontWeight.w600,
                ),
              ],
            ),

            const SizedBox(height: 4),

            SizedBox(
              width: Get.width * 0.5,
              child: Utils.textViewPro(
                widget.item.subtitle,
                Get.width * 0.035,
                CustomColors.black,
                FontWeight.w500,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
          
          
          ],
        ),
      ),

      /// STATUS BADGE
      Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          widget.item.status.replaceAll('_', ' ').capitalizeFirst ?? '',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
        ),
      ),

         
     
     
    ],
  ),
      ),

    );
  }
}

