import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/models/food.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key, required this.tabController});

  final TabController tabController;

  List<Tab> _kategoriMakanan() {
    return FoodCategory.values.map((e) {
      return Tab(
        icon: Icon(
          _getIconCategory(e),
        ),
      );
    }).toList();
  }

  IconData _getIconCategory(FoodCategory category) {
    switch (category) {
      case FoodCategory.mainCourse:
        return Icons.restaurant;
      case FoodCategory.salads:
        return Icons.eco;
      case FoodCategory.pasta:
        return Icons.dinner_dining_rounded;
      case FoodCategory.desserts:
        return Icons.cake;
      case FoodCategory.drinks:
        return Icons.coffee_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      indicatorColor: Colors.brown.shade500,
      labelColor: Colors.brown.shade500,
      unselectedLabelColor: Theme.of(context).colorScheme.inversePrimary,
      tabs: _kategoriMakanan(),
      dividerColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
