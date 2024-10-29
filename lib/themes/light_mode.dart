import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
  primary: Colors.blue,
  secondary: const Color.fromARGB(255, 245, 249, 255),
  surface: const Color.fromARGB(255, 255, 255, 255),
  surfaceTint: const Color.fromARGB(255, 66, 176, 255),
  tertiary: Colors.grey.shade400,
  inversePrimary: Colors.grey.shade800,
  onError: Colors.white,
  error: Colors.red,
));
