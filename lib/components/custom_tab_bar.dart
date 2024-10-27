import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/models/food.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key, required this.tabController});

  final TabController tabController;

  List<Tab> _kategoriMakanan() {
    return FoodCategory.values.map((e) {
      return Tab(
        text: e.toString().split('.').last,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      indicatorColor: Colors.green,
      labelColor: Colors.green,
      tabs: _kategoriMakanan(),
      dividerColor: Theme.of(context).colorScheme.tertiary,
    );
  }
}
