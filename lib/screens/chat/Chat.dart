import 'package:flutter/material.dart';
import 'package:skin_chek/screens/chat/ChatItem.dart';
import 'package:skin_chek/screens/chat/chat_hook.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ChatHook? viewModel;
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> chat = [
    {
      "message": "Kulit saya gatal dan muncul ruam merah.",
      "isSender": true,
      "date": "08:01",
    },
    {
      "message": "Sudah berapa lama gejala ini muncul?",
      "isSender": false,
      "date": "08:01",
    },
    {"message": "Sekitar 3 hari terakhir.", "isSender": true, "date": "08:02"},
    {
      "message": "Apakah Anda merasa perih atau panas pada kulit tersebut?",
      "isSender": false,
      "date": "08:03",
    },
    {
      "message": "Iya, terutama saat berkeringat.",
      "isSender": true,
      "date": "08:03",
    },
    {
      "message": "Apakah Anda baru saja mengganti sabun atau deterjen?",
      "isSender": false,
      "date": "08:04",
    },
    {
      "message": "Saya baru coba sabun mandi baru minggu ini.",
      "isSender": true,
      "date": "08:04",
    },
    {
      "message": "Kemungkinan kulit Anda iritasi karena sabun tersebut.",
      "isSender": false,
      "date": "08:05",
    },
    {
      "message": "Apakah ini termasuk alergi?",
      "isSender": true,
      "date": "08:06",
    },
    {
      "message":
          "Bisa jadi, namun perlu diperiksa langsung untuk memastikannya.",
      "isSender": false,
      "date": "08:06",
    },
    {
      "message": "Saya juga melihat ada kulit yang mengelupas.",
      "isSender": true,
      "date": "08:07",
    },
    {
      "message": "Itu bisa menjadi gejala dermatitis kontak atau eksim.",
      "isSender": false,
      "date": "08:07",
    },
    {
      "message": "Obat apa yang bisa saya pakai?",
      "isSender": true,
      "date": "08:08",
    },
    {
      "message": "Gunakan salep hidrokortison tipis-tipis 2 kali sehari.",
      "isSender": false,
      "date": "08:08",
    },
    {
      "message": "Apakah perlu ke dokter kulit?",
      "isSender": true,
      "date": "08:09",
    },
    {
      "message":
          "Jika tidak membaik dalam 3–5 hari, sebaiknya konsultasi langsung.",
      "isSender": false,
      "date": "08:09",
    },
    {
      "message": "Oke, saya akan coba salep dulu.",
      "isSender": true,
      "date": "08:10",
    },
    {
      "message": "Jangan lupa juga untuk hentikan pemakaian sabun yang baru.",
      "isSender": false,
      "date": "08:10",
    },
    {
      "message": "Terima kasih atas sarannya!",
      "isSender": true,
      "date": "08:11",
    },
    {
      "message": "Sama-sama, semoga lekas membaik.",
      "isSender": false,
      "date": "08:11",
    },
  ];

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 16,
                ),
                children:
                    chat.map((ch) {
                      return ChatItem(
                        message: ch['message'],
                        isSender: ch['isSender'],
                        date: ch['date'],
                      );
                    }).toList(),
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
