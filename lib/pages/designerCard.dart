import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/modal/designnermodal.dart';
import 'package:customer_app_planzaa/pages/designerServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';


class DesignerCard extends StatelessWidget {
  final DesignerItem item;
  // final DesignerItem designerId;
  final String currencySymbol;

  const DesignerCard({
    super.key,
    required this.item,
    required this.currencySymbol,
    //required this.designerId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Network Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.image,
              width: 130,
              height: 130,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.person, size: 130),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                   Utils.textView(
                        item.name,
                          Get.width * 0.045,
                          CustomColors.black,
                          FontWeight.bold, 
                        ), 
               
                const SizedBox(height: 4),

                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < item.rating
                          ? Icons.star
                          : Icons.star_border,
                      size: 14,
                      color: Colors.orangeAccent,
                    );
                  }),
                ),

                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                           Utils.textView(
                        "${item.projectsDone} Projects",
                          Get.width * 0.035,
                          CustomColors.black,
                          FontWeight.normal, 
                        ), 
                        Utils.textView(
                        "$currencySymbol${item.amount}",
                          Get.width * 0.035,
                          CustomColors.black,
                          FontWeight.normal, 
                        ), 
                       
                      ],
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F3C88),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        Get.to(()=>DesignerServices(item: item, designerId: item.id,));
                        // Get.find<BottomNavController>().openInner(
                        //   page: DesignerServices(item: item, designerId: item.id, ),
                        //   title: "Designer Services",
                        // );
                      },
                      child: 
                       Utils.textView(
                        "Request",
                          Get.width * 0.038,
                          CustomColors.white,
                          FontWeight.bold, 
                        ), 
                     
                      
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
