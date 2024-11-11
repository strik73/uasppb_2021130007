import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminDetailPage extends StatelessWidget {
  final String orderId;

  const AdminDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Order details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #$orderId',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      Text('Customer Name: ${order['customerName']}'),
                      Text('Status: ${order['status']}'),
                      Text(
                          'Order Date: ${(order['orderDate'] as Timestamp).toDate()}'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                //Order items and price
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Total Price :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              order['totalPrice'] != null
                                  ? NumberFormat.currency(
                                          decimalDigits: 2,
                                          symbol: 'Rp.',
                                          locale: 'id_ID')
                                      .format(order['totalPrice'])
                                  : 'N/A',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 18),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(indent: 4, endIndent: 4),
                        const SizedBox(height: 8),
                        const Text('Items Ordered:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: (order['items'] as List).length,
                            itemBuilder: (context, index) {
                              final item = order['items'][index];
                              final itemTotalPrice =
                                  item['price'] * item['quantity'];
                              return ListTile(
                                title: Text(item['name']),
                                subtitle: Text('Quantity: ${item['quantity']}'),
                                trailing: Text(
                                  NumberFormat.currency(
                                          decimalDigits: 0,
                                          symbol: 'Rp.',
                                          locale: 'id_ID')
                                      .format(itemTotalPrice),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
