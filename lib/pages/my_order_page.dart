import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uasppb_2021130007/components/custom_drawer.dart';
import 'package:uasppb_2021130007/pages/admin_detail_page.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  final ScrollController _scrollController = ScrollController();
  final List<DocumentSnapshot> _orders = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _loadOrders();
      }
    });
  }

  Future<void> _loadOrders() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .orderBy('orderDate', descending: true)
        .limit(5);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
      setState(() {
        _orders.addAll(snapshot.docs);
      });
    } else {
      setState(() {
        _hasMore = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('My Orders'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Divider(
              color: Theme.of(context).colorScheme.inversePrimary,
              thickness: 2,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length + ((_hasMore && _isLoading) ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _orders.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final order = _orders[index].data() as Map<String, dynamic>;

                return Card(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      '#${_orders[index].id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Order Date: ${order['orderDate'] != null ? DateFormat('HH:mm:ss, dd-MM-yyyy').format((order['orderDate'] as Timestamp).toDate()) : 'N/A'}',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ordered Items:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (order['items'] != null)
                          ...List.generate(
                            (order['items'] as List).length,
                            (itemIndex) {
                              final item = order['items'][itemIndex];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 4.0),
                                child: Text(
                                  '${item['name']} x${item['quantity']}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              );
                            },
                          ),
                        Divider(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: ${order['totalPrice'] != null ? NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.').format(order['totalPrice']) : 'N/A'}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
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
                                        : Colors.grey.shade500.withOpacity(0.2),
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
                        if (value == 'info') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdminDetailPage(orderId: _orders[index].id),
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => [
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
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
