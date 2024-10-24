import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/components/custom_drawer.dart';
import 'package:uasppb_2021130007/components/custom_sliver_app_bar.dart';
import 'package:uasppb_2021130007/components/custom_tab_bar.dart';
import 'package:uasppb_2021130007/components/custom_table_number.dart';

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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
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
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      //table number
                      CustomTableNumber(),
                    ],
                  ),
                ),
              ],
          body: TabBarView(
            controller: _tabController,
            children: [
              Text("Hello"),
              Text("Hello"),
              Text("Hello"),
            ],
          )),
    );
  }
}
