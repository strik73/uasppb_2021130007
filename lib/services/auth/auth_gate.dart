import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/pages/admin_page.dart';
import 'package:uasppb_2021130007/pages/chef_page.dart';
import 'package:uasppb_2021130007/pages/home_page.dart';
import 'package:uasppb_2021130007/services/auth/auth_service.dart';
import 'package:uasppb_2021130007/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<String>(
              future: AuthService().getUserRole(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.hasData) {
                  // Route to different pages based on role
                  switch (roleSnapshot.data) {
                    case 'admin':
                      return const AdminPage();
                    case 'chef':
                      return const ChefPage();
                    case 'user':
                      return const HomePage();
                    default:
                      return const LoginOrRegister();
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
