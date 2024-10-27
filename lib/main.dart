import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/auth/login_or_register.dart';
import 'package:provider/provider.dart';
import 'package:uasppb_2021130007/firebase_options.dart';
import 'package:uasppb_2021130007/models/resto.dart';
import 'package:uasppb_2021130007/themes/theme_provide.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => Resto()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginOrRegister(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
