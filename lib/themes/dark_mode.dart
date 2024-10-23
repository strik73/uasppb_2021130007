import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme.dark(
  primary: const Color.fromARGB(255, 121, 121, 121),
  secondary: const Color.fromARGB(255, 28, 28, 28),
  surface: const Color.fromARGB(255, 18, 18, 18),
  tertiary: const Color.fromARGB(255, 50, 50, 50),
  inversePrimary: Colors.grey.shade300,
  onError: Colors.white,
  error: Colors.red,
));
