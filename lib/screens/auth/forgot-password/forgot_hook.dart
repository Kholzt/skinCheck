import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skin_chek/utils/google_service.dart';

class LoginHook {
  final emailController = TextEditingController();
  final GoogleAuthService _authService = GoogleAuthService();
  BuildContext context;
  String message = "";
  String errorMessage = "";
  bool isLoading = false;
  LoginHook({required this.context});

  String? emailValidator(val) {
    if (val == null || val.isEmpty) return "Email wajib diisi";
    if (!val.contains("@")) return "Format email tidak valid";
    return null;
  }

  Future<void> forgotPassword(VoidCallback callback) async {
    try {
      message = "";
      callback();
      final email = emailController.text;
      isLoading = true;
      await _authService.sendPasswordResetEmail(email);
      // emailController.clear();
      message = "Tautan berhasil dikirim, silahkan cek di gmail anda";
      callback();
      isLoading = false;
    } on FirebaseAuthException catch (e) {
      errorMessage = "Terjadi kesalahan ketika mengirim tautan";
      callback();
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
  }
}
