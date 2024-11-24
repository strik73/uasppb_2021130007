import 'package:flutter/material.dart';
// import 'package:uasppb_2021130007/pages/add_menu_page.dart';
import 'package:uasppb_2021130007/pages/admin_history_page.dart';
import 'package:uasppb_2021130007/pages/admin_manage_menu.dart';
import 'package:uasppb_2021130007/pages/admin_page.dart';
import 'package:uasppb_2021130007/services/auth/auth_service.dart';
import 'package:uasppb_2021130007/components/custom_drawer_tile.dart';
import 'package:uasppb_2021130007/pages/settings_page.dart';
import 'package:uasppb_2021130007/services/auth/login_or_register.dart';

class CustomAdminDrawer extends StatelessWidget {
  const CustomAdminDrawer({super.key});

  void logout(BuildContext context) async {
    final authService = AuthService();
    authService.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'lib/images/cashier_logo.png',
                    height: 80,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Admin Panel",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          //drawer tile
          CustomDrawerTile(
            text: "Pending Orders",
            icon: Icons.pending_actions,
            color: Theme.of(context).colorScheme.inversePrimary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminPage(),
                ),
              );
            },
          ),
          CustomDrawerTile(
            text: "Order History",
            icon: Icons.history,
            color: Theme.of(context).colorScheme.inversePrimary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminHistoryPage(),
                ),
              );
            },
          ),
          CustomDrawerTile(
            text: "Manage Menu",
            icon: Icons.menu,
            color: Theme.of(context).colorScheme.inversePrimary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminManageMenu(),
                ),
              );
            },
          ),
          CustomDrawerTile(
            text: "Settings",
            icon: Icons.settings,
            color: Theme.of(context).colorScheme.inversePrimary,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          ),

          const Spacer(),

          CustomDrawerTile(
            text: "Log Out",
            icon: Icons.logout,
            color: Theme.of(context).colorScheme.error,
            onTap: () => logout(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
