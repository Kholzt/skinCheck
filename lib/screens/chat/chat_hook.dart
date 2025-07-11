import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skin_chek/screens/chat/Chat.dart';
import 'package:skin_chek/screens/home/home.dart';
import 'package:skin_chek/screens/layouts/app.dart';
import 'package:skin_chek/utils/google_service.dart';

class ChatHook {
  final messageController = TextEditingController();
  BuildContext context;

  ChatHook({required this.context});
  String? messageValidator(val) {
    if (val == null || val.isEmpty) return "Pesan wajib diisi";
    return null;
  }

  void dispose() {
    messageController.dispose();
  }
}
