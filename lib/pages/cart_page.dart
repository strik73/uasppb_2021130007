import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/components/custom_button.dart';
import 'package:uasppb_2021130007/components/custom_cart_tile.dart';
import 'package:uasppb_2021130007/models/resto.dart';
import 'package:provider/provider.dart';
import 'package:uasppb_2021130007/pages/payment_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Resto>(builder: (context, resto, child) {
      final userCart = resto.cart;

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          title: const Text("Keranjang"),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Peringatan"),
                          content: const Text(
                              "Apakah anda yakin ingin menghapus semua item dari keranjang?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Tidak"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                resto.clearCart();
                              },
                              child: const Text("Ya"),
                            ),
                          ],
                        ));
              },
              icon: const Icon(Icons.delete_forever_rounded),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  userCart.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.remove_shopping_cart_outlined,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Keranjang kosong",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: userCart.length,
                            itemBuilder: (context, index) {
                              final cartItem = userCart[index];
                              return CustomCartTile(cartItem: cartItem);
                            },
                          ),
                        ),
                ],
              ),
            ),
            CustomButton(
              text: "Bayar Sekarang",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentPage()));
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }
}
