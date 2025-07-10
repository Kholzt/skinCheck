import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_chek/screens/login/login_view_model.dart';
import 'package:skin_chek/widgets/button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: vm.setEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                onChanged: vm.setPassword,
              ),
              const SizedBox(height: 32),
              Button(text: "Login", onPressed: vm.submit),
            ],
          ),
        ),
      ),
    );
  }
}
