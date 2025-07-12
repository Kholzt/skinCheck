import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skin_chek/screens/chat/Chat.dart';
import 'package:skin_chek/screens/home/home.dart';
import 'package:skin_chek/screens/layouts/app.dart';
import 'package:skin_chek/utils/google_service.dart';

class LoginHook {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GoogleAuthService _authService = GoogleAuthService();
  BuildContext context;
  bool showPassword = true;

  LoginHook({required this.context});
  void togglePassword(VoidCallback updateUI) {
    showPassword = !showPassword;
    updateUI(); // Panggil setState() dari UI
  }

  String? passwordValidator(val) {
    if (val == null || val.isEmpty) return "Password wajib diisi";
    if (val.length < 6) return "Minimal 6 karakter";
    return null;
  }

  String? emailValidator(val) {
    if (val == null || val.isEmpty) return "Email wajib diisi";
    if (!val.contains("@")) return "Format email tidak valid";
    return null;
  }

  /// 🔐 Login dengan email dan password
  Future<void> loginWithEmailPassword() async {
    try {
      final email = emailController.text;
      final password = passwordController.text;
      User? user = await _authService.signInWithEmailPassword(email, password);
      if (user != null) {
        print("✅ Login berhasil: ${user.email}");

        Navigator.pushReplacementNamed(context, "/chat");
      } else {
        _showError(context, "Pengguna belum terdaftar");
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("❌ Login gagal: ${e.message}");
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      User? user = await _authService.signInWithGoogle();
      Navigator.pushReplacementNamed(context, '/chat');

      debugPrint("✅ Login dengan Google berhasil");
    } on FirebaseAuthException catch (e) {
      debugPrint("❌ Login Google gagal: ${e.message}");
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
