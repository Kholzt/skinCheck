import 'package:flutter/material.dart';
import 'package:skin_chek/screens/chat/chat_hook.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ChatHook? viewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    viewModel = ChatHook(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset(
          "assets/images/logo-home.png",
          height: 30,
          fit: BoxFit.contain,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  Text("Belum ada pesan..."), // Ganti dengan daftar pesan nanti
                ],
              ),
            ),

            // 👇 Input Chat di bawah
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //     blurRadius: 4,
                //     color: Colors.grey.withOpacity(0.2),
                //     offset: const Offset(0, -1),
                //   ),
                // ],
              ),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    // Tombol attachment
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () {
                        // TODO: handle attachment
                      },
                    ),

                    // Input pesan
                    Expanded(
                      child: TextFormField(
                        controller: viewModel!.messageController,
                        decoration: InputDecoration(
                          hintText: "Tulis pesan...",
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Tombol kirim
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          print("Kirim: ${viewModel!.messageController.text}");
                          viewModel!.messageController.clear();
                        }
                      },
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // efek ripple mengikuti bentuk
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // 👈 atur sudut di sini
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
