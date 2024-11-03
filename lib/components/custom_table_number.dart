import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uasppb_2021130007/models/resto.dart';

class CustomTableNumber extends StatelessWidget {
  const CustomTableNumber({super.key});

  void openTableSearch(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nomor Meja"),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
              hintText: "Masukan nomor meja...",
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.tertiary)),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          MaterialButton(
            onPressed: () {
              String newTableNumber = textController.text;
              context.read<Resto>().setTableNumber(newTableNumber);
              Navigator.pop(context);
            },
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
      child: Container(
        margin: const EdgeInsets.only(left: 50, right: 50),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Table Number",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Theme.of(context).colorScheme.tertiary,
              indent: 10,
              endIndent: 10,
            ),
            GestureDetector(
              onTap: () => openTableSearch(context),
              child: Center(
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min, // This helps keep the Row centered
                  children: [
                    Consumer<Resto>(builder: (context, resto, child) {
                      return Text(
                        resto.tableNumber.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
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
      ),
    );
  }
}
