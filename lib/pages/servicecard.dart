import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/servicecontroller.dart';
import 'package:customer_app_planzaa/modal/servicemodal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem item;
  final int index;
  final bool compact;

  ServiceCard({
    super.key,
    required this.item,
    required this.index,
    this.compact = false,
  });

  final ServiceController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.isSelected(index);

      return GestureDetector(
        onTap: () => controller.toggleSelection(index),
        child: Container(
          padding: compact
              ? const EdgeInsets.symmetric(horizontal: 5, vertical: 5)
              : const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? CustomColors.blue : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.19),
                blurRadius: 12,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    item.image,
                    height: compact ? 60 : Get.height * 0.08,
                    width: compact ? 60 : Get.width * 0.12,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Utils.textView(
                          item.title,
                          compact ? Get.width * 0.045 : Get.width * 0.028,
                          CustomColors.black,
                          FontWeight.bold, 
                        ), 


                        if (!compact) ...[ 
                          const SizedBox(height: 4),
                          Utils.textView(
                            item.subtitle,
                              Get.width * 0.025,
                            CustomColors.black,
                            FontWeight.w400,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              if (!compact &&
                  (item.isPopular || item.badge != null))
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE28B2D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Utils.textView(
                      item.badge != null
                          ? (item.badge == "most_popular"
                          ? "Most Popular"
                          : "Popular")
                          : "Popular",
                      Get.width * 0.025,
                      CustomColors.white,
                      FontWeight.bold,
                    ),
                  ),
                ),

            ],
          ),
        ),
      );
    });
  }  
}
