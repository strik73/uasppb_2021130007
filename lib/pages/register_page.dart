import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/components/custom_button.dart';
import 'package:uasppb_2021130007/components/custom_textfield.dart';
import 'package:uasppb_2021130007/services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  void register() async {
    setState(() {
      _isLoading = true;
    });

    final _authService = AuthService();
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        final result = await _authService.signUp(
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        //jika berhasil
        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registration successful!"),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _isLoading = false; // Hide loading on error
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      setState(() {
        _isLoading = false; // Hide loading if passwords don't match
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Password tidak sama"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 100,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 20),
                Text(
                  "Buat Akun Baru",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                //textfield email & password
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
                const SizedBox(height: 10),
                CustomTextField(
                    hintText: "Confirm Password",
                    icon: Icons.lock,
                    controller: _confirmPasswordController,
                    obscureText: true),
                const SizedBox(height: 25),
                CustomButton(text: "Daftar", onTap: register),
                const SizedBox(height: 25),
                //text register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah punya akun?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Masuk sekarang",
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
          if (_isLoading) // Show loading overlay when _isLoading is true
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
