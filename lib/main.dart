import 'package:flutter/material.dart';
import 'package:skin_chek/screens/home/home.dart';
import 'package:skin_chek/splash.dart';
import 'package:skin_chek/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
      home:  Splash(),
    );
  }
}
