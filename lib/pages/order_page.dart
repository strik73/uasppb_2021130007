import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/components/bon_pembayaran.dart';
import 'package:uasppb_2021130007/components/custom_button.dart';
import 'package:uasppb_2021130007/models/resto.dart';
import 'package:uasppb_2021130007/pages/home_page.dart';
import 'package:uasppb_2021130007/services/auth/login_or_register.dart';
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

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      firestoreService.saveOrder(context.read<Resto>());
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginOrRegister(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order in progress"),
      ),
      body: Column(
        children: [
          const BonPembayaran(),
          const SizedBox(
            height: 20,
          ),
          Consumer<Resto>(
            builder: (context, resto, child) {
              return CustomButton(
                onTap: () {
                  resto.clearCart();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                text: 'Kembali',
              );
            },
          ),
        ],
      ),
    );
  }
}
