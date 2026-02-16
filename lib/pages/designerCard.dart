import 'package:customer_app_planzaa/modal/designnermodal.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:planzaa_app/modal/designnermodal.dart';
// import '../../../utils/app_fonts.dart';
// import '../../../widget/controller/bottomnavcontroller.dart';
// import '../Designer Services/screen/designerServices.dart';

// class DesignerCard extends StatelessWidget {
//   final DesignerItem item;
//
//   const DesignerCard({
//     super.key,
//     required this.item,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     int rating = int.tryParse(item.review) ?? 0;
//
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(6),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Image
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.asset(
//               item.image,
//               width: 130,
//               height: 130,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           /// Content
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(item.name, style: AppFonts.desHead()),
//
//                 const SizedBox(height: 4),
//
//                 Row(
//                   children: List.generate(5, (index) {
//                     return Icon(
//                       index < rating ? Icons.star : Icons.star_border,
//                       size: 14,
//                       color: Colors.orangeAccent,
//                     );
//                   }),
//                 ),
//
//                 //const SizedBox(height: 6),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(item.projects, style: AppFonts.prosubHead()),
//                         Text(item.rate, style: AppFonts.prosubHead()),
//                       ],
//                     ),
//
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF1F3C88),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         minimumSize: const Size(0, 32),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                       onPressed: () {
//                         Get.find<BottomNavController>().openInner(
//                           page: DesignerServices(item: item),
//                           title: "Designer Services",
//                         );
//                       },
//                       child: Text("Request", style: AppFonts.button(height: 1.0,)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
                Text(item.name, 
                // style: AppFonts.desHead()
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
                        Text("${item.projectsDone} Projects", 
                        // style: AppFonts.prosubHead()
                        ),
                        Text("$currencySymbol${item.amount}", 
                        // style: AppFonts.prosubHead()
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
                        // Get.find<BottomNavController>().openInner(
                        //   page: DesignerServices(item: item, designerId: item.id, ),
                        //   title: "Designer Services",
                        // );
                      },
                      child: Text("Request", 
                      // style: AppFonts.button(height: 1.0,)
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
