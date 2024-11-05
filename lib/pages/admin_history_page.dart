import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uasppb_2021130007/components/custom_admin_drawer.dart';

class AdminHistoryPage extends StatefulWidget {
  const AdminHistoryPage({super.key});

  @override
  State<AdminHistoryPage> createState() => _AdminHistoryPageState();
}

class _AdminHistoryPageState extends State<AdminHistoryPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAdminDrawer(),
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search order',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('status', isNotEqualTo: 'Pending')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = snapshot.data!.docs.where((doc) {
                  final order = doc.data() as Map<String, dynamic>;
                  final customerName =
                      (order['customerName'] ?? '').toString().toLowerCase();
                  final orderId = doc.id.toLowerCase();

                  return customerName.contains(searchQuery) ||
                      orderId.contains(searchQuery);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index].data() as Map<String, dynamic>;

                    return Card(
                      color: Theme.of(context).colorScheme.secondary,
                      child: ListTile(
                        title: Text(
                          'ORDER #${orders[index].id}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer: ${order['customerName'] ?? 'N/A'}'),
                            Text(
                                'Total: ${order['totalPrice'] != null ? NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.').format(order['totalPrice']) : 'N/A'}'),
                            Text(
                              'Order Date: ${order['orderDate'] != null ? DateFormat('HH:mm:ss, dd-MM-yyyy').format((order['orderDate'] as Timestamp).toDate()) : 'N/A'}',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Status: ${order['status'] ?? 'N/A'}',
                              style: TextStyle(
                                color: order['status'] == 'Approved'
                                    ? Colors.yellow.shade700
                                    : order['status'] == 'Rejected'
                                        ? Colors.red
                                        : order['status'] == 'Completed'
                                            ? Colors.green
                                            : Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
