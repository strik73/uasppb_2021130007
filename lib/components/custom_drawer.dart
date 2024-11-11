import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/services/auth/auth_service.dart';
import 'package:uasppb_2021130007/components/custom_drawer_tile.dart';
import 'package:uasppb_2021130007/pages/settings_page.dart';
import 'package:uasppb_2021130007/services/auth/login_or_register.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
            child: Icon(Icons.food_bank,
                size: 90, color: Theme.of(context).colorScheme.inversePrimary),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          //drawer tile
          CustomDrawerTile(
            text: "Home",
            icon: Icons.home,
            color: Theme.of(context).colorScheme.inversePrimary,
            onTap: () => Navigator.pop(context),
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
