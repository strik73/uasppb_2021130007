import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
  primary: Colors.blue,
  secondary: const Color.fromARGB(255, 239, 239, 239),
  surface: const Color.fromARGB(255, 255, 255, 255),
  tertiary: Colors.grey.shade400,
  inversePrimary: Colors.grey.shade800,
  onError: Colors.white,
  error: Colors.red,
));
