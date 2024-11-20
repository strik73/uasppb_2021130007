import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/models/food.dart';
import 'package:intl/intl.dart';

class FoodTile extends StatefulWidget {
  const FoodTile({super.key, required this.food, required this.onTap});

  final Food food;
  final void Function()? onTap;

  @override
  State<FoodTile> createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {
  String? fullPath;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 12.0, left: 12.0, right: 12.0, bottom: 12.0),
            child: Row(
              children: [
                //gambar makanan
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.food.imagePath,
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                //deskripsii makanan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.food.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.food.description,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currencyFormatter.format(widget.food.price),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold),
                      ), // Formatted price
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.tertiary,
          indent: 15,
          endIndent: 15,
          thickness: 1,
        ),
      ],
    );
  }
}
