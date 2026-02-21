import 'package:customer_app_planzaa/common/appBar.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/paymentController.dart';
import 'package:customer_app_planzaa/controller/projectDetailController.dart';
import 'package:customer_app_planzaa/modal/choosePackageModel.dart';
import 'package:customer_app_planzaa/modal/designnermodal.dart';
import 'package:customer_app_planzaa/modal/paymentResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class PaymentScreen extends StatefulWidget {
  final String orderNo;
  final int projectId;
  final int designerId;
  final double subTotal;
  final double tax;
  final double totalAmount;
  final DesignerItem? item;
   final String jobType; 
 final DesignerItem designer; 
 final int  seriviceId;
 final String serviceName;
 
  const PaymentScreen({
    super.key,
    required this.orderNo,
    required this.projectId,
    required this.designerId,
    required this.subTotal,
    required this.tax,
    required this.totalAmount,
     this.item, 
     required this.jobType, 
     required this.designer, 
     required this.seriviceId, 
     required this.serviceName,
  }); 

  @override
  State<PaymentScreen> createState() => _PaymentScreenState(); 
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  late PaymentController paymentController;
late ProjectDetailController projectController;
  @override
  void initState() {
    super.initState();
    paymentController = Get.put(PaymentController(this));
      print("Designer services: ${widget.item?.services}");

     //projectController = Get.put(ProjectDetailController(this));

 // projectController.getProjectDetails(widget.projectId);

  print("PROJECT ID: ${widget.projectId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: const CustomAppBar(title: "Payment"),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(18),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Utils.textView(
//                     'Order ',
//                     Get.width * 0.04,
//                     CustomColors.black,
//                     FontWeight.w500,
//                   ),
//                   Utils.textView(
//                     widget.orderNo,
//                     Get.width * 0.04,
//                     CustomColors.black,
//                     FontWeight.w600,
//                   ),
//                 ],
//               ),
//               SizedBox(height: Get.height * 0.02),
//               Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 8,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 12,
//                                     spreadRadius: 2,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child:  CircleAvatar(
//   radius: 28,
//   backgroundImage: (widget.item != null && widget.item!.image.isNotEmpty)
//       ? NetworkImage(widget.item!.image)
//       : null,
//   child: (widget.item == null || widget.item!.image.isEmpty)
//       ? const Icon(Icons.person, size: 28)
//       : null,
// ),



//                             ),

//                             const SizedBox(width: 12),

//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [

//                                  Utils.textView(
//                     widget.item!.name,
//                     Get.width * 0.04,
//                     CustomColors.black,
//                     FontWeight.w600,
//                   ),
                             
//                                  Utils.textView(
//                      widget.jobType,
//                     Get.width * 0.04,
//                     CustomColors.black,
//                     FontWeight.w400,
//                   ),
                           
                                
//                               ],
//                             ),
//                           ],
//                         ),
//                         // AppSizes.paySize(),
//                         // Divider(height: Get.height * 0.04),
//                         // // AppSizes.paySize(),
                        
//                         // _serviceRow(widget.item!.services, widget.item!.amount,),
//          GetBuilder<ProjectDetailController>(
//   builder: (controller) {

//     if (controller.projectDetailModel == null) {
//       return const Padding(
//         padding: EdgeInsets.all(12),
//         child: CircularProgressIndicator(),
//       );
//     }

//  final services =
//     controller.projectDetailModel?.data?.result?.services ?? [];

// // if (services.isEmpty) {
// //   return const Padding(
// //     padding: EdgeInsets.all(8),
// //     child: Text("No services found"),
// //   );
// // } 

// return Column(
//   children: services.map<Widget>((service) {

//     final serviceName = service.serviceName ?? '';
//     final serviceStatus = service.status ?? '';

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: _serviceRow(
//         serviceName,
//         serviceStatus,
//       ),
//     );

//   }).toList(),
// );
//   },
// ),
//                         // // AppSizes.paySize(),
//                         Divider(height: Get.height * 0.01),
//                         // // AppSizes.paySize(),
//                         // _serviceRow('Interior Design', '₹5,000'), 
//                         // AppSizes.paySize(),
// //                       Column(
// //   crossAxisAlignment: CrossAxisAlignment.start,
// //   children: [ 
// //     if (widget.item != null && widget.item!.services.isNotEmpty)
// //       ...widget.item!.services.map<Widget>((service) {
// //         String serviceName = "";

        
// //         if (service is Map<String, dynamic>) {
// //           serviceName = service['name'] ?? '';
// //         }
       
// //         else if (service is String) {
// //           serviceName = service;
// //         }

// //         return Padding(
// //           padding: const EdgeInsets.symmetric(vertical: 4),
// //           child: Text(
// //             serviceName,
// //             style: TextStyle(
// //               fontSize: Get.width * 0.038,
// //               fontWeight: FontWeight.w500,
// //               color: CustomColors.black,
// //             ),
// //           ),
// //         );
// //       }).toList(),
// //   ],
// // )

//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: Get.height * 0.01),
//               Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 8,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 12,
//                                     spreadRadius: 2,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: const CircleAvatar(
//                                 radius: 28,
//                                 backgroundImage: AssetImage(
//                                   'assets/images/profile2.jpg',
//                                 ),
//                               ),
//                             ),

//                             const SizedBox(width: 12),

//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Taylor Russell',
//                                   // style: AppFonts.heading(size: 16),
//                                 ),
//                                 // const SizedBox(height: 4),
//                                 Text(
//                                   'Surveyor',
//                                   // style: AppFonts.prosubHead(
//                                   //   size: 12,
//                                   //   color: AppColors.textSecondary3,
//                                   // ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         // AppSizes.paySize(),
//                         Divider(height: Get.height * 0.01),
//                         // AppSizes.paySize(),
//                         _serviceRow('Total Earn', '₹1,000'),

//                         //  AppSizes.paySize(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: Get.height * 0.01),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Payment Summary',
//                     // style: AppFonts.heading(size: 16),
//                   ),
//                   SizedBox(height: Get.height * 0.01),
//                   Column(
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.12),
//                               blurRadius: 8,
//                               offset: const Offset(0, 6),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 10),

//                             /// Subtotal
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.file_copy_outlined,
//                                     size: 20,
//                                     color: Colors.blueGrey,
//                                   ),
//                                   const SizedBox(width: 10),
//                                   _serviceRow1('Subtotal', '₹6,000'),
//                                 ],
//                               ),
//                             ),

//                             // AppSizes.paySize(),
//                             Divider(height: Get.height * 0.01),
//                             // AppSizes.paySize(),

//                             /// GST
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.receipt_long,
//                                     size: 20,
//                                     color: Colors.blueGrey,
//                                   ),
//                                   const SizedBox(width: 10),
//                                   _serviceRow1('GST (18%)', '₹1,080'),
//                                 ],
//                               ),
//                             ),

//                             // AppSizes.paySize(),
//                             Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 14,
//                                 horizontal: 12,
//                               ),
//                               decoration: const BoxDecoration(
//                                 color: Color(0xFFF1F6FF),
//                                 borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(12),
//                                   bottomRight: Radius.circular(12),
//                                 ),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.assignment_outlined,
//                                     size: 22,
//                                     color: Colors.blueGrey,
//                                   ),
//                                   const SizedBox(width: 12),

//                                   Expanded(
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           'Grand Total',
//                                           // style: AppFonts.payment()
//                                         ),
//                                         const SizedBox(width: 6),
//                                         const Icon(
//                                           Icons.check_circle_rounded,
//                                           // color: AppColors.paymentTick,
//                                           size: 18,
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   Text(
//                                     '₹7,080',
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       SizedBox(height: Get.height * 0.001),
//                       SafeArea(
//                         child: SizedBox(
//                           width: double.infinity,
//                           height: 40,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF1F3C88),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                             ),
//                             onPressed: () {
//                               paymentController.checkout(
//                                 orderNumber: widget.orderNo,
//                                 projectId: widget.projectId,
//                                 designerId: widget.designerId,
//                                 subTotal: widget.subTotal,
//                                 tax: widget.tax,
//                                 totalAmount: widget.totalAmount,
//                               );
//                             },

//                             child: Text(
//                               "Pay ₹7,080",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: Get.height * 0.01),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'By proceteding, I accept the ',
//                             // style: AppFonts.payment1()
//                           ),
//                           Text(
//                             'Terms ',
//                             // style: AppFonts.payment11()
//                           ),
//                           Text(
//                             'and ',
//                             // style: AppFonts.payment1()
//                           ),
//                           Text(
//                             'Conditions. ',
//                             // style: AppFonts.payment11()
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
    
    );
  
  
  }

  Widget _serviceRow(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          // style: AppFonts.payment()
        ),
        Text(
          price,
          // style: AppFonts.payment()
        ),
      ],
    );
  }

  Widget _serviceRow1(String title, String amount) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            // style: AppFonts.payment()
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }


}
