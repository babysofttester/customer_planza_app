import 'package:customer_app_planzaa/modal/orderHistoryResponseModel.dart';
import 'package:customer_app_planzaa/modal/orderModal.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:planzaa_app/modal/orderModal.dart';
// import '../../../../utils/app_color.dart';
// import '../../../../utils/app_fonts.dart';
// import '../../../../utils/app_size.dart';

class OrderDetail extends StatefulWidget {
  final OrderItem? item;
  const OrderDetail({super.key, this.item, required Result order});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {

  bool _isExpanded = false;

  Color statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF5BAF47);
      case 'incompleted':
        return const Color(0xFFF4A546);
      case 'pending':
        return const Color(0xFF6F67C5);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.item?.status ?? '';
    final isCompleted = status.toLowerCase() == 'completed';

    final services =
        widget.item!.services.split(',').map((e) => e.trim()).toList() ?? [];

    debugPrint('Service: ${services}');

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Order', 
                  // style: AppFonts.proHead2()
                  ),
                  Text(' ${widget.item?.orderId ?? ''}',
                      // style: AppFonts.proHead()
                      ),
                ],
              ),

              SizedBox(height: Get.height * 0.02),

              /// ===== SERVICES CARD =====
              Container(
                margin: const EdgeInsets.only(bottom: 16),
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
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 28,
                              backgroundImage:
                              AssetImage('assets/profile2.jpg'),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Adam Collins',
                                    // style: AppFonts.heading(size: 16)
                                    ),
                                Text(
                                  'Designer',
                                  // style: AppFonts.prosubHead(
                                  //   size: 12,
                                  //   color: AppColors.textSecondary3,
                                  // ),
                                ),
                              ],
                            ),
                          ],
                        ),


                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Container(
                            height: 26,
                            width: 26,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2B2B2B),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// EXPANDABLE SERVICES
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: _isExpanded
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Column(
                        children: services
                            .map(
                              (service) => Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: _projectRow(
                              title: service,
                              isCompleted: isCompleted,
                              showDownload: isCompleted,
                            ),
                          ),
                        )
                            .toList(),
                      ),
                      secondChild: const SizedBox(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Get.height * 0.01),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
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
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 28,
                                backgroundImage: AssetImage(
                                  'assets/profile2.jpg',
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Taylor Russell',
                                  // style: AppFonts.heading(size: 16),
                                ),
                                // const SizedBox(height: 4),
                                Text(
                                  'Surveyor',
                                  // style: AppFonts.prosubHead(
                                  //   size: 12,
                                  //   color: AppColors.textSecondary3,
                                  // ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // AppSizes.paySize(),
                        Divider(height: Get.height * 0.01),
                        // AppSizes.paySize(),
                        _serviceRow('Total Earn', '₹1,000'),

                        //  AppSizes.paySize(),

                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Summary',  
                  // style: AppFonts.heading(size: 16),
                  ),
                  SizedBox(height: Get.height * 0.01),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),

                            /// Subtotal
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.file_copy_outlined,
                                      size: 20, color: Colors.blueGrey),
                                  const SizedBox(width: 10),
                                  _serviceRow1('Subtotal', '₹6,000'),
                                ],
                              ),
                            ),

                            // AppSizes.paySize(),
                            Divider(height: Get.height * 0.01),
                            // AppSizes.paySize(),

                            /// GST
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.receipt_long,
                                      size: 20, color: Colors.blueGrey),
                                  const SizedBox(width: 10),
                                  _serviceRow1('GST (18%)', '₹1,080'),
                                ],
                              ),
                            ),

                            // AppSizes.paySize(),


                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF1F6FF),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.assignment_outlined,
                                      size: 22, color: Colors.blueGrey),
                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text('Grand Total', 
                                        // style: AppFonts.payment()
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          // color: AppColors.paymentTick,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    '₹7,080',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceRow(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, 
        // style: AppFonts.payment()
        ),
        Text(price, 
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
          Text(title, 
          // style: AppFonts.payment()
          ),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
  Widget _projectRow({
    required String title,
    required bool isCompleted,
    required bool showDownload,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, 
        //  / style: AppFonts.payment()
          )),

          Icon(
            isCompleted
                ? Icons.check_circle
                : Icons.check_circle_outline_rounded,
            color: isCompleted ? Colors.green : Colors.orange,
            size: 20,
          ),

          if (showDownload) ...[
            const SizedBox(width: 10),
            const Icon(Icons.cloud_download_outlined,
                color: Color(0xFF1F3C88), size: 20),
          ],
        ],
      ),
    );
  }

}
