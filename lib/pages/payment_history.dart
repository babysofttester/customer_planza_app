import 'package:customer_app_planzaa/common/appBar.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/controller/paymentHistoryController.dart';
import 'package:customer_app_planzaa/pages/paymentCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:customer_app_planzaa/modal/choosePackageModel.dart' hide Result;
import 'package:customer_app_planzaa/modal/paymentHistoryResponseModel.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';



class PaymentHistory extends StatefulWidget {

  const PaymentHistory({super.key, });

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> with TickerProviderStateMixin {
  late final PaymentHistoryController paymentHistorycontroller;

@override
void initState() {
  super.initState();
  paymentHistorycontroller = Get.put(PaymentHistoryController(this));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: const CustomAppBar(title: "Payment History"), 
     body: SafeArea(
  child: Obx(() {
    if (paymentHistorycontroller.payments.isEmpty) {
      return const Center(
        child: Text("No Payment History Found"),
      ); 
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: paymentHistorycontroller.payments.length, 
      itemBuilder: (context, index) {
        final item = paymentHistorycontroller.payments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: PaymentCard(item: item),
        );
      },
    );
  }),
),
    );
  }
}

