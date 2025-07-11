import 'package:flutter/material.dart';
import 'package:skin_chek/utils/google_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = (GoogleAuthService()).getUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 40,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user!.displayName ?? "Anonym",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Text(
                  "Selamat Datang!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(child: Column(children: [

          ],
        )),
    );
  }
}
