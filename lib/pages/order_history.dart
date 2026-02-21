import 'package:customer_app_planzaa/controller/orderHistoryController.dart';
import 'package:customer_app_planzaa/modal/orderModal.dart';
import 'package:customer_app_planzaa/pages/order_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'orderCard.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> with TickerProviderStateMixin {
  late final OrderHistoryController orderHistoryController;

  @override
  void initState() {
    super.initState();
    orderHistoryController = Get.put(OrderHistoryController(this));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
  if (orderHistoryController.orders.isEmpty) {
    return Center(
      child: Text('No Order Found'),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: orderHistoryController.orders.length,
    itemBuilder: (context, index) {
      final item = orderHistoryController.orders[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: () {
            Get.to(() => OrderDetail(order: item)); 
          },
          child: OrderCard(item: item),
        ),
      );
    },
  );
})
      ),
    );
  }
}