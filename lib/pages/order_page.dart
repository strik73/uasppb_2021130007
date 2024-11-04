import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/components/bon_pembayaran.dart';
import 'package:uasppb_2021130007/models/resto.dart';
import 'package:uasppb_2021130007/services/database/firestore.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();

    firestoreService.saveOrder(context.read<Resto>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order in progress"),
      ),
      body: const BonPembayaran(),
    );
  }
}
