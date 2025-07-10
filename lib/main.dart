import 'package:flutter/material.dart';
import 'package:skin_chek/splash.dart';
import 'package:skin_chek/utils/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skin Check',
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      home: const Splash(),
    );
  }
}
