import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/models/food.dart';

class QtySelector extends StatelessWidget {
  const QtySelector(
      {super.key,
      required this.qty,
      required this.food,
      required this.onIncrement,
      required this.onDecrement});

  final int qty;
  final Food food;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).colorScheme.primary,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: const Icon(
              Icons.remove,
              color: Colors.white,
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 18,
                child: Center(
                  child: Text(
                    qty.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              )),
          GestureDetector(
            onTap: onIncrement,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
