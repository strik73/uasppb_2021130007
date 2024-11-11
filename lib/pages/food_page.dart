import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uasppb_2021130007/components/custom_button.dart';
import 'package:uasppb_2021130007/models/food.dart';
import 'package:uasppb_2021130007/models/resto.dart';
import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key, required this.food});

  final Food food;

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  void addToCart(Food food) {
    context.read<Resto>().addToCart(food);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  widget.food.imagePath,
                  height: 300,
                  width: 500,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.food.name,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      Text(
                        widget.food.category.toString().split('.').last,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        widget.food.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: Theme.of(context).colorScheme.tertiary,
                        indent: 0,
                        endIndent: 10,
                      ),
                      const SizedBox(height: 25),
                      Text(
                        "Price",
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currencyFormatter.format(widget.food.price),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 25),
                      Divider(
                        color: Theme.of(context).colorScheme.tertiary,
                        indent: 25,
                        endIndent: 25,
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        onTap: () => addToCart(widget.food),
                        text: "Add to Cart",
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        SafeArea(
          child: Opacity(
            opacity: 0.9,
            child: Container(
              margin: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
