import 'package:customer_app_planzaa/pages/paymentCard.dart';
import 'package:flutter/material.dart';
// import 'package:planzaa_app/module/Payment/Payment%20History/screen/paymentCard.dart';
import '../../../../modal/paymentModal.dart';


class PaymentHistory extends StatelessWidget {
  final PaymentItem? item;
  const PaymentHistory({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: payment.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PaymentCard(
                item: payment[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

