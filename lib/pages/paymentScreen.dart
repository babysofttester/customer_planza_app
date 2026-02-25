import 'package:customer_app_planzaa/common/appBar.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/paymentController.dart';
import 'package:customer_app_planzaa/controller/projectDetailController.dart';
import 'package:customer_app_planzaa/modal/choosePackageModel.dart';
import 'package:customer_app_planzaa/modal/designnermodal.dart';
import 'package:customer_app_planzaa/modal/paymentResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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


@override 
void initState() {
  super.initState();

  paymentController = Get.put(PaymentController(this));

  paymentController.getCartDetails(
    projectId: widget.projectId.toString(),
    designerId: widget.designerId.toString(),
  );

  print("PROJECT ID: ${widget.projectId}");
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: const CustomAppBar(title: "Payment"),
      body: Obx(() {
  final cartModel = paymentController.cartDetailModel.value;

  if (cartModel == null ||
      cartModel.data == null ||
      cartModel.data!.result == null) {
    return const Center();
  }

  final result = cartModel.data!.result!;
  final services = result.services ?? [];

  double subtotal = 0;

  for (var service in services) {
    String priceString = service.totalPrice ?? '0';

    priceString =
        priceString.replaceAll('₹', '').replaceAll(',', '');

    subtotal += double.tryParse(priceString) ?? 0;
  }

  double gst = subtotal * 0.18;
  double grandTotal = subtotal + gst;


  double surveyorAmount =
    double.tryParse(result.surveyorTotal ?? "0") ?? 0;

bool showSurveyor =
    result.jobType == "designer_surveyor" &&
    surveyorAmount > 0;

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
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
                result.orderNo ?? "",
                Get.width * 0.04,
                CustomColors.black,
                FontWeight.w600,
              ),
            ],
          ),

          SizedBox(height: Get.height * 0.02),

         
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [

            
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          result.designer?.avatar != null
                              ? NetworkImage(result.designer!.avatar!)
                              : null,
                      child: result.designer?.avatar == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Utils.textView(
                          result.designer?.name ?? "",
                          Get.width * 0.04,
                          CustomColors.black,
                          FontWeight.w600,
                        ),
                        Utils.textView(
                          result.jobType ?? "",
                          Get.width * 0.04,
                          CustomColors.black,
                          FontWeight.w400,
                        ),
                      ],
                    ),
                  ],
                ),

                const Divider(),

            
                Column(
                  children: services.map((service) {
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 4),
                      child: _serviceRow(
                        service.serviceName ?? "",
                        service.totalPrice ?? "",
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          SizedBox(height: Get.height * 0.02),





if (showSurveyor) ...[
  Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Utils.textView(
          'Surveyor Total',
          Get.width * 0.04,
          CustomColors.black,
          FontWeight.w600,
        ),
        Utils.textView(
          "₹${surveyorAmount.toStringAsFixed(0)}",
          Get.width * 0.04,
          CustomColors.black,
          FontWeight.w400,
        ),
      ],
    ),
  ),

  SizedBox(height: Get.height * 0.02), 
],
        
        
        
        Container(
  decoration: BoxDecoration(  
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 6),
      ),
    ],
  ),
  child: Column(
    children: [
      _PaymentRow(
        icon: Icons.receipt_long,
        title: 'Subtotal',
        amount: '₹${subtotal.toStringAsFixed(0)}',
      ),
      const Divider(height: 1),

      _PaymentRow(
        icon: Icons.percent,
        title: 'GST (18%)',
           amount: '₹${gst.toStringAsFixed(0)}',
      ),
      const Divider(height: 1),

      _PaymentRow(
        icon: Icons.assignment,
        title: 'Grand Total',
        amount: '₹${grandTotal.toStringAsFixed(0)}',
        isBold: true,
      ),
    ],
  ),
),
          SizedBox(height: Get.height * 0.02),

 
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF1F3C88),
              ),
              onPressed: () {
                paymentController.openCheckout(
                  orderNumber:
                      result.orderNo ?? "",
                  amount: grandTotal,
                  name: result.designer?.name ?? "",
                  description:
                      "Payment for Order ${result.orderNo}",
                );
              },
              child: Text(
                "Pay ₹${grandTotal.toStringAsFixed(0)}",
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}),
    );
  
  
  }

  Widget _serviceRow(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Utils.textView(
                    title,
                    Get.width * 0.04,
                    CustomColors.black,
                    FontWeight.w400, 
                  ),
                           
       

        Utils.textView(
                    price,
                    Get.width * 0.04,
                    CustomColors.black,
                    FontWeight.w400, 
                  ),
      ],
    );
  }

  Widget _serviceRow1(String title, String amount) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
        Utils.textView(
                    title,
                    Get.width * 0.04,
                    CustomColors.black,
                    FontWeight.w400, 
                  ),
        
          
        Utils.textView(
                    amount,
                    Get.width * 0.04,
                    CustomColors.black,
                    FontWeight.w400, 
                  ),
        
        ],
      ),
    );
  }


}
class _PaymentRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool isBold;
  final IconData icon;

  const _PaymentRow({
    required this.title,
    required this.amount,
    this.isBold = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isGrandTotal = isBold;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isGrandTotal
            ? Color.fromARGB(255, 245, 247, 255)
            : Colors.transparent,
        borderRadius: isGrandTotal
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              )
            : BorderRadius.zero,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isGrandTotal
                    ? const Color(0xFF1F3C88)
                    : CustomColors.boxColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: isGrandTotal ? 15 : 14,
                  fontWeight:
                      isGrandTotal ? FontWeight.bold : FontWeight.w500,
                  color: Colors.black,
                ),
              ),

              if (isGrandTotal) ...[
                const SizedBox(width: 6),
                const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ]
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isGrandTotal ? 18 : 14,
              fontWeight:
                  isGrandTotal ? FontWeight.bold : FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}