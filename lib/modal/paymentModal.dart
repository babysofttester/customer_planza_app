class PaymentItem {
  final String projectId;
  final String transId;
  final String amount;
  final String dateTime;
  final String payMethod;

  PaymentItem({
    required this.projectId,
    required this.transId,
    required this.amount,
    required this.dateTime,
    required this.payMethod,
  });
}

final payment = [
  PaymentItem(
    projectId: '#223456',
    transId: ' #124462',
    amount: '20,000.00',
    dateTime: '3:00 PM - Jan 02, 2025',
    payMethod: 'Upi',
),
  PaymentItem(
    projectId: '#223457',
    transId: ' #124466',
    amount: '20,000.00',
    dateTime: '3:00 PM - Jan 02, 2025',
    payMethod: 'Upi',
  ),
  PaymentItem(
    projectId: '#223458',
    transId: ' #124423',
    amount: '20,000.00',
    dateTime: '3:00 PM - Jan 02, 2025',
    payMethod: 'Upi',
  ),
  PaymentItem(
    projectId: '#223459',
    transId: ' #124499',
    amount: '20,000.00',
    dateTime: '3:00 PM - Jan 02, 2025',
    payMethod: 'Upi',
  ),
  PaymentItem(
    projectId: '#223460',
    transId: ' #124422',
    amount: '20,000.00',
    dateTime: '3:00 PM - Jan 02, 2025',
    payMethod: 'Upi',
  ),
  PaymentItem(
    projectId: '#223461',
    transId: ' #124658',
    amount: '20,000.00',
    dateTime: '3:00 PM - Jan 02, 2025',
    payMethod: 'Upi',
  ),
];