import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uasppb_2021130007/components/qty_selector.dart';
import 'package:uasppb_2021130007/models/cart_item.dart';
import 'package:uasppb_2021130007/models/resto.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class CustomCartTile extends StatefulWidget {
  const CustomCartTile({super.key, required this.cartItem});

  final CartItem cartItem;

  @override
  State<CustomCartTile> createState() => _CustomCartTileState();
}

class _CustomCartTileState extends State<CustomCartTile> {
  @override
  void initState() {
    super.initState();
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  }

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
              child: CachedNetworkImage(
                imageUrl: widget.cartItem.food.imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cartItem.food.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${widget.cartItem.quantity} x ${currencyFormatter.format(widget.cartItem.food.price)}',
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
                qty: widget.cartItem.quantity,
                food: widget.cartItem.food,
                onDecrement: () {
                  resto.removeFromCart(widget.cartItem);
                },
                onIncrement: () {
                  resto.addToCart(widget.cartItem.food);
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
