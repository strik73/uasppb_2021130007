import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uasppb_2021130007/models/resto.dart';

class BonPembayaran extends StatelessWidget {
  const BonPembayaran({super.key});

  Widget buildPaymentInstructions(BuildContext context) {
    final resto = Provider.of<Resto>(context);
    String instructions = resto.getPaymentInstructions();

    if (instructions == "QRIS") {
      return Column(
        children: [
          Image.asset(
            'lib/images/qris.jpg',
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 10),
        ],
      );
    } else if (instructions == "BANK") {
      return Column(
        children: [
          Image.asset(
            'lib/images/bca.png',
            width: 100,
            height: 100,
          ),
          const Text(
            "1234567890\nYefta Steven Marcellius",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return Text(
        instructions,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
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
            const SizedBox(height: 20),
            const Divider(),
            buildPaymentInstructions(context),
          ],
        ),
      ),
    );
  }
}
