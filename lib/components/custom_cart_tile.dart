import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uasppb_2021130007/components/qty_selector.dart';
import 'package:uasppb_2021130007/models/cart_item.dart';
import 'package:uasppb_2021130007/models/resto.dart';
import 'package:intl/intl.dart';

class CustomCartTile extends StatelessWidget {
  const CustomCartTile({super.key, required this.cartItem});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Consumer<Resto>(
      builder: (context, resto, child) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(cartItem.food.imagePath,
                  height: 100, width: 100, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.food.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${cartItem.quantity} x ${currencyFormatter.format(cartItem.food.price)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 45,
              child: QtySelector(
                qty: cartItem.quantity,
                food: cartItem.food,
                onDecrement: () {
                  resto.removeFromCart(cartItem);
                },
                onIncrement: () {
                  resto.addToCart(cartItem.food);
                },
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
