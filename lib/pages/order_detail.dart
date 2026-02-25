import 'package:customer_app_planzaa/common/appBar.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/orderDetailController.dart';
import 'package:customer_app_planzaa/modal/orderHistoryResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetail extends StatefulWidget {
  //final Result item;  
   final String bookingNo;

  const OrderDetail({
    super.key,
   required this.bookingNo,
  });


  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> with TickerProviderStateMixin{
  // final OrderDetailController controller =
  //     Get.put(OrderDetailController());

  bool _isExpanded = false;

late final OrderDetailController controller;

@override
void initState() {
  super.initState();
  controller = Get.put(OrderDetailController(this, widget.bookingNo));
  //controller.fetchOrderDetail(widget.bookingNo ?? '');
}


String role = '';



  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
       backgroundColor: CustomColors.white,
      appBar: const CustomAppBar(title: "Order Details"),
      body: Obx(() {
        // if (controller.isLoading.value) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        final data = controller.orderDetail.value;

        if (data == null) {
          return const Center(child: Text("No order data found"));
        }

        final services = data.services ?? [];
        double subtotal = 0;

for (var service in services) {
  String priceString = service.totalPrice ?? '0';


  priceString = priceString.replaceAll('₹', '').replaceAll(',', '');

  subtotal += double.tryParse(priceString) ?? 0;
}

double gst = subtotal * 0.18;
double grandTotal = subtotal + gst;

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
                     widget.bookingNo,
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

    /// DESIGNER ROW
    Row(
  children: [
    CircleAvatar(
      radius: 28,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: (data.designer?.avatar != null &&
              data.designer!.avatar!.isNotEmpty)
          ? NetworkImage(data.designer!.avatar!)
          : null,
      child: (data.designer?.avatar == null ||
              data.designer!.avatar!.isEmpty)
          ? const Icon(Icons.person,
              size: 28, color: Colors.grey)
          : null,
    ),
    const SizedBox(width: 12),

    
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utils.textView(
            data.designer?.name ??
                data.surveyor?.name ??
                '',
            Get.width * 0.04,
            CustomColors.black,
            FontWeight.w600,
          ),

          Utils.textView(
            data.designer != null
                ? "Designer"
                : data.surveyor != null
                    ? "Surveyor"
                    : "",
            Get.width * 0.04,
            CustomColors.textGrey,
            FontWeight.w400,
          ),
        ],
      ),
    ),
  ],
),
    const SizedBox(height: 16),
    const Divider(),


    Column(
      children: services.map((service) {
        return Column(
          children: [
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                 Utils.textView(
                     service.serviceName ?? '',
                      Get.width * 0.038,
                      CustomColors.black,
                      FontWeight.w500,
                    ),
                    Utils.textView(
                     service.totalPrice ?? '',
                      Get.width * 0.038,
                      CustomColors.black,
                      FontWeight.w400,
                    ),
               
              ],
            ),
            const SizedBox(height: 5),
            const Divider(),
          ],
        );
      }).toList(),
    ),
  ],
),
                ),

                SizedBox(height: Get.height * 0.03),

                
                 Align(
                  alignment: Alignment.centerLeft,
                  child: Utils.textView(
                      'Payment Summary',
                      Get.width * 0.045,
                      CustomColors.black,
                      FontWeight.w600,
                    ),
                  
                ),

                const SizedBox(height: 12),
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
              
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _projectRow({
    required String title,
    required bool isCompleted,
    required bool showDownload,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Icon(
            isCompleted
                ? Icons.check_circle
                : Icons.check_circle_outline,
            color:
                isCompleted ? Colors.green : Colors.orange,
          ),
          if (showDownload) ...[
            const SizedBox(width: 10),
            const Icon(Icons.cloud_download_outlined),
          ],
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