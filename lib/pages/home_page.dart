import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uasppb_2021130007/components/custom_drawer.dart';
import 'package:uasppb_2021130007/components/custom_food_tile.dart';
import 'package:uasppb_2021130007/components/custom_sliver_app_bar.dart';
import 'package:uasppb_2021130007/components/custom_tab_bar.dart';
import 'package:uasppb_2021130007/components/custom_table_number.dart';
import 'package:uasppb_2021130007/models/food.dart';
import 'package:uasppb_2021130007/models/resto.dart';
import 'package:uasppb_2021130007/pages/food_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController =
        TabController(length: FoodCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  //menampilkan makanan sesuai kategori
  List<Food> _filterFood(FoodCategory category, List<Food> foods) {
    return foods.where((element) => element.category == category).toList();
  }

  List<Widget> getFood(List<Food> foods) {
    return FoodCategory.values.map((e) {
      List<Food> filteredFood = _filterFood(e, foods);

      return ListView.builder(
        itemBuilder: (context, index) {
          final food = filteredFood[index];
          return FoodTile(
            food: food,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodPage(food: food),
              ),
            ),
          );
        },
        itemCount: filteredFood.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 2),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CustomSliverAppBar(
            title: CustomTabBar(tabController: _tabController),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  indent: 25,
                  endIndent: 25,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  thickness: 2,
                ),
                //table number
                CustomTableNumber(),
              ],
            ),
          ),
        ],
        body: Consumer<Resto>(
          builder: (context, resto, child) => TabBarView(
            controller: _tabController,
            children: getFood(resto.menu),
          ),
        ),
      ),
    );
  }
}
