import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:planzaa_app/utils/app_color.dart';

// import '../../../../utils/app_fonts.dart';
// import '../../../../utils/app_size.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
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
                  Text(' #223456', 
                  // style: AppFonts.proHead()
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
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
                                  'Adam Collins',
                                  // style: AppFonts.heading(size: 16),
                                ),
                               // const SizedBox(height: 4),
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
                        // AppSizes.paySize(),
                        Divider(height: Get.height * 0.01),
                        // AppSizes.paySize(),
                        _serviceRow('2D & 3D Design', '₹1,000'),

                        // AppSizes.paySize(),
                        Divider(height: Get.height * 0.01),
                        // AppSizes.paySize(),
                        _serviceRow('Interior Design', '₹5,000'),
                        // AppSizes.paySize(),
                      ],
                    ),
                  ),
                ],
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

                      SizedBox(height: Get.height * 0.001),
                      SafeArea(
                        child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1F3C88),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () {

                            },
                            child: Text(
                              "Pay ₹7,080",
                              style: TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('By proceteding, I accept the ',
                          // style: AppFonts.payment1()
                          )
                          ,
                          Text('Terms ', 
                          // style: AppFonts.payment11()
                          ),
                          Text('and ',
                          // style: AppFonts.payment1()
                          ),
                          Text('Conditions. ',
                          // style: AppFonts.payment11()
                          ),
                        ],
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

}
