import 'package:flutter/material.dart';

class CustomTableNumber extends StatelessWidget {
  const CustomTableNumber({super.key});

  void openTableSearch(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nomor Meja"),
        content: TextField(
          decoration: InputDecoration(
              hintText: "Masukan nomor meja...",
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.tertiary)),
        ),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Table Number",
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
          GestureDetector(
            onTap: () => openTableSearch(context),
            child: Center(
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // This helps keep the Row centered
                children: [
                  Text(
                    "Table 1",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
