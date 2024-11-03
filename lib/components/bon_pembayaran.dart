import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uasppb_2021130007/models/resto.dart';

class BonPembayaran extends StatelessWidget {
  const BonPembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Center(
        child: Column(
          children: [
            Text("Thank you for ordering!"),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.tertiary),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.all(25),
              child: Consumer<Resto>(
                builder: (context, resto, child) => Text(
                  resto.displayBon(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
