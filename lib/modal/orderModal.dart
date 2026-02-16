class OrderItem {
  final String orderId;
  final String name;
  final String amount;
  final String date;
  final String status;
  final String services;

  OrderItem({
    required this.orderId,
    required this.name,
    required this.amount,
    required this.date,
    this.status = " ",
    required this.services,
  });
}

final order = [
  OrderItem(
    orderId: '#223456',
    name: 'Taylor Russell',
    amount: '7,000',
    date: 'Jan 02, 2026',
    status: 'Completed',
    services: '2D Design, 3D Design,  MEP layouts, Interior Design',
  ),
  OrderItem(
    orderId: '#223456',
    name: 'Adam Collins',
    amount: '5,000',
    date: 'Jan 02, 2026',
    status: 'InCompleted',
    services: '2D Design',
  ),
  OrderItem(
    orderId: '#223456',
    name: 'Jessica Morgan',
    amount: '2,000',
    date: 'Jan 02, 2026',
    status: 'Completed',
    services: ' Structural drawings, Interior Design',
  ),
  OrderItem(
    orderId: '#223456',
    name: 'John Doe',
    amount: '9,000',
    date: 'Jan 02, 2026',
    status: 'Completed',
    services: '2D Design, 3D Design,  MEP layouts, Structural drawings',
  ),
  OrderItem(
    orderId: '#223456',
    name: 'Taylor Russell',
    amount: '7,000',
    date: 'Jan 02, 2026',
    status: 'InCompleted',
    services: ' 3D Design,  MEP layouts, Interior Design',
  ),
  OrderItem(
    orderId: '#223456',
    name: 'Taylor Russell',
    amount: '7,000',
    date: 'Jan 02, 2026',
    status: 'Completed',
    services: '2D Design,  Structural drawings, Interior Design',
  ),
  OrderItem(
    orderId: '#223456',
    name: 'Taylor Russell',
    amount: '7,000',
    date: 'Jan 02, 2026',
    status: 'InCompleted',
    services: '2D Design, Interior Design',
  ),


];
