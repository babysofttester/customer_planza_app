import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../../../modal/orderModal.dart';
// import '../../../../widget/controller/bottomnavcontroller.dart';
// import '../../Order Detail/screen/order_detail.dart';
import 'orderCard.dart';

class OrderHistory extends StatelessWidget {
  final OrderItem? item;
  const OrderHistory({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: order.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  // Get.find<BottomNavController>().openInner(
                  //   page: OrderDetail(item: order[index]),
                  //   title: "Order Details",
                  // );
                },
                  child: OrderCard( item: order[index],)),
            );
          },
        ),
      ),
    );
  }
}
