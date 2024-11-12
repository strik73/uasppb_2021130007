import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uasppb_2021130007/components/custom_admin_drawer.dart';
import 'package:uasppb_2021130007/pages/admin_detail_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAdminDrawer(),
      appBar: AppBar(
        title: const Text('Pending Orders'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or order ID',
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
                  .where('status', isEqualTo: 'Pending')
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: order['status'] == 'Approved'
                                    ? Colors.yellow.shade700.withOpacity(0.2)
                                    : order['status'] == 'Rejected'
                                        ? Colors.red.withOpacity(0.2)
                                        : order['status'] == 'Completed'
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.grey.shade500
                                                .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: order['status'] == 'Approved'
                                      ? Colors.yellow.shade800
                                      : order['status'] == 'Rejected'
                                          ? Colors.red
                                          : order['status'] == 'Completed'
                                              ? Colors.green
                                              : Colors.grey.shade700,
                                ),
                              ),
                              child: Text(
                                'Status: ${order['status'] ?? 'N/A'}',
                                style: TextStyle(
                                  color: order['status'] == 'Approved'
                                      ? Colors.yellow.shade800
                                      : order['status'] == 'Rejected'
                                          ? Colors.red
                                          : order['status'] == 'Completed'
                                              ? Colors.green
                                              : Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          onSelected: (value) async {
                            if (value == 'accept') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Accept'),
                                  content: const Text(
                                      'Are you sure you want to accept this order?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Accept'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(orders[index].id)
                                    .update({'status': 'Approved'});
                              }
                            } else if (value == 'reject') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Reject'),
                                  content: const Text(
                                      'Are you sure you want to reject this order?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Reject'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(orders[index].id)
                                    .update({'status': 'Rejected'});
                              }
                            } else if (value == 'info') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminDetailPage(
                                      orderId: orders[index].id),
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'accept',
                              child: Row(
                                children: [
                                  Icon(Icons.check, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text('Accept Order'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              onTap: null,
                              value: 'reject',
                              child: Row(
                                children: [
                                  Icon(Icons.close, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Reject Order'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'info',
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Order Detail'),
                                ],
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
