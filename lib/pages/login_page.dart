import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/components/custom_button.dart';
import 'package:uasppb_2021130007/components/custom_textfield.dart';
import 'package:uasppb_2021130007/pages/admin_page.dart';
import 'package:uasppb_2021130007/pages/chef_page.dart';
import 'package:uasppb_2021130007/pages/home_page.dart';
import 'package:uasppb_2021130007/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login() async {
    final _authService = AuthService();
    try {
      await _authService.signIn(
          _emailController.text, _passwordController.text);

      //get user role
      String userRole = await _authService.getUserRole();

      if (!mounted) return;

      switch (userRole) {
        case 'admin':
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AdminPage()));
          break;
        case 'chef':
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ChefPage()));
          break;
        case 'user':
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid user role')),
          );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                'lib/images/decafe.jpg',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Welcome to De'Cafe!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
                hintText: "Email",
                icon: Icons.email,
                controller: _emailController),
            const SizedBox(height: 10),
            CustomTextField(
                hintText: "Password",
                icon: Icons.lock,
                controller: _passwordController,
                obscureText: true),
            const SizedBox(height: 25),
            CustomButton(text: "Masuk", onTap: login),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Belum punya akun?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Daftar sekarang",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
