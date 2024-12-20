import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uasppb_2021130007/models/resto.dart';
import 'package:uasppb_2021130007/pages/cart_page.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar(
      {super.key, required this.child, required this.title});

  final Widget child;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        expandedHeight: 240,
        collapsedHeight: 120,
        floating: false,
        pinned: true,
        actions: [
          Consumer<Resto>(
            builder: (context, resto, child) => IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPage(),
                  ),
                );
              },
              icon: resto.cart.isEmpty
                  ? Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )
                  : Badge.count(
                      count: resto.cart.length,
                      child: Icon(
                        Icons.shopping_cart,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
            ),
          ),
        ],
        title: Text("De'Cafe"),
        centerTitle: true,
        flexibleSpace: FlexibleSpaceBar(
          background: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: child,
          ),
          title: title,
          centerTitle: true,
          titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 0),
          expandedTitleScale: 1,
        ));
  }
}
