import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, // 👈 change to your desired color
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset(
          "assets/images/logo-home.png",
          height: 30,
          fit: BoxFit.contain,
        ),
      ),
      body: SafeArea(child: Text("DSA")),
    );
  }
}
