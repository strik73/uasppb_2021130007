import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide.none),
      ),
      child: TabBar(
        controller: tabController,
        indicatorColor: Colors.transparent,
        tabs: [
          Tab(icon: Icon(Icons.restaurant)),
          Tab(icon: Icon(Icons.wine_bar)),
        ],
      ),
    );
  }
}
