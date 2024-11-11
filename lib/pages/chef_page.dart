import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uasppb_2021130007/components/custom_chef_drawer.dart';

class ChefPage extends StatefulWidget {
  const ChefPage({super.key});

  @override
  State<ChefPage> createState() => _ChefPageState();
}

class _ChefPageState extends State<ChefPage> {
  final ScrollController _scrollController = ScrollController();
  static const int ordersPerPage = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoading = false;
  List<DocumentSnapshot> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadMoreOrders();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreOrders();
    }
  }

  Future<void> _loadMoreOrders() async {
    if (!_hasMore || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'Approved')
        .orderBy('orderDate', descending: true)
        .limit(ordersPerPage);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshots = await query.get();

    if (snapshots.docs.length < ordersPerPage) {
      _hasMore = false;
    }

    if (snapshots.docs.isNotEmpty) {
      _lastDocument = snapshots.docs.last;
      _orders.addAll(snapshots.docs);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomChefDrawer(),
      appBar: AppBar(
        title: const Text('All Orders'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _orders.length) {
            return _hasMore
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox();
          }

          final order = _orders[index].data() as Map<String, dynamic>;

          return Card(
            color: Theme.of(context).colorScheme.secondary,
            child: ListTile(
              title: Text(
                'ORDER #${_orders[index].id}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    'Order Time: ${order['orderDate'] != null ? DateFormat('HH:mm | dd-MM-yyyy').format((order['orderDate'] as Timestamp).toDate()) : 'N/A'}',
                  ),
                  const SizedBox(height: 8),
                  Text('Customer: ${order['customerName'] ?? 'N/A'}'),
                  Text('Table Number: ${order['tableNumber'] ?? 'N/A'}'),
                  const SizedBox(height: 8),
                  if (order['items'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ordered Items:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...List.from(order['items']).map((item) => Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child:
                                  Text('${item['name']} x${item['quantity']}'),
                            )),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              trailing: IconButton(
                icon: const Icon(Icons.check_box_outlined),
                color: Colors.green,
                iconSize: 45,
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text(
                            'Are you sure you want to complete this order?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(_orders[index].id)
                                  .update({
                                'status': 'Completed',
                              });

                              // Reset and reload all orders
                              setState(() {
                                _orders = [];
                                _lastDocument = null;
                                _hasMore = true;
                              });

                              await _loadMoreOrders();
                              Navigator.pop(context);
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
