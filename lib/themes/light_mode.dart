import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
  primary: const Color.fromARGB(255, 110, 63, 30),
  secondary: const Color.fromARGB(255, 255, 242, 231),
  surface: const Color.fromARGB(255, 255, 255, 255),
  surfaceTint: const Color.fromARGB(255, 66, 176, 255),
  tertiary: const Color.fromARGB(255, 158, 158, 158),
  inversePrimary: Colors.brown.shade900,
  onError: Colors.white,
  error: Colors.red,
));
