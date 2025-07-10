import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String _email = "";
  String _password = "";

  void setEmail(String val) {
    _email = val;
    notifyListeners();
  }

  void setPassword(String val) {
    _password = val;
    notifyListeners();
  }

  String get email => _email;
  String get password => _password;

  void submit() {
    // Simulasi validasi atau proses login
    debugPrint('Email: $_email, Password: $_password');
  }
}
