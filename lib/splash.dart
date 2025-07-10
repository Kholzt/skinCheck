import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              secondary, // Dominan warna atas
              primary, // Dominan warna atas
              // secondary.withOpacity(0.8),
              // primary.withOpacity(0.6),
              // primary.withOpacity(0.4),
            ],
          ),
        ),
        child:  Center(
          child: Image.asset(
            'assets/images/logo-depan.png', // pastikan nama & path sesuai
            width: 150,
            height: 150,
                fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
