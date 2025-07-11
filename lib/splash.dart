import 'package:flutter/material.dart';
import 'package:skin_chek/screens/chat/Chat.dart';
import 'package:skin_chek/screens/layouts/app.dart';
import 'package:skin_chek/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_chek/screens/home/home.dart'; // ganti dengan halaman kamu

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _topBubbleController;
  late Animation<Offset> _topBubbleOffset;

  late AnimationController _bottomBubbleController;
  late Animation<Offset> _bottomBubbleOffset;

  late AnimationController _logoController;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    // Animasi bubble atas kiri
    _topBubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _topBubbleOffset = Tween<Offset>(
      begin: const Offset(-1.5, -1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _topBubbleController, curve: Curves.easeOut),
    );

    // Animasi bubble bawah kanan
    _bottomBubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bottomBubbleOffset = Tween<Offset>(
      begin: const Offset(1.5, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _bottomBubbleController, curve: Curves.easeOut),
    );

    // Animasi logo
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    // Jalankan animasi
    _topBubbleController.forward();
    _bottomBubbleController.forward();
    _logoController.forward();

    // Cek login setelah delay
    Future.delayed(const Duration(seconds: 2), () {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Sudah login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Chat(),
          ), // ganti dengan halaman utama kamu
        );
      } else {
        // Belum login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      }
    });
  }

  @override
  void dispose() {
    _topBubbleController.dispose();
    _bottomBubbleController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [secondary, primary],
              ),
            ),
          ),
          Positioned(
            top: -50,
            left: -50,
            child: SlideTransition(
              position: _topBubbleOffset,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  color: secondary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: SlideTransition(
              position: _bottomBubbleOffset,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _logoOpacity,
              child: ScaleTransition(
                scale: _logoScale,
                child: Image.asset(
                  'assets/images/logo-depan.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
