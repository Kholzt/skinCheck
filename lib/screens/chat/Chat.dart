import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skin_chek/data/models/ChatItemModel.dart';
import 'package:skin_chek/data/models/ChatModel.dart';
import 'package:skin_chek/main.dart';
import 'package:skin_chek/screens/chat/ChatItem.dart';
import 'package:skin_chek/screens/chat/Drawer.dart';
import 'package:skin_chek/screens/chat/chat_hook.dart';

class Chat extends StatefulWidget {
  final String? chatId;
  const Chat({super.key, this.chatId});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ChatHook viewModel = ChatHook();
  final _formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  List<ChatItemModel> chat = [];
  List<ChatModel> chats = [];

  bool isOnline = isOnlineNotifier.value;

  File? selectedImage;
  String? base64Image;

  @override
  void initState() {
    super.initState();
    if (widget.chatId != null) {
      viewModel.setChatId(widget.chatId);
    }
    viewModel.setContext(context);
    fetchChat();
    isOnlineNotifier.addListener(() {
      setState(() {
        isOnline = isOnlineNotifier.value;
      });
    });
  }

  Future<void> fetchChat() async {
    try {
      final chatsHistory = await viewModel.getChat();
      final allChat = await viewModel.getAllChat();

      setState(() {
        chat = chatsHistory;
        chats = allChat;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    } catch (e) {
      debugPrint("Error loading chat: $e");
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        final bytes = selectedImage!.readAsBytesSync();
        base64Image = base64Encode(bytes);
      });
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> handleSend(String message) async {
    if ((!isOnline) || (message.trim().isEmpty && base64Image == null)) return;

    setState(() {
      chat.add(
        ChatItemModel(
          message: message.isNotEmpty ? message : "[Gambar dikirim]",
          image_base64: base64Image,
          sender: "user",
          created_at: DateTime.now().toIso8601String(),
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

    messageController.clear();

    if (message.isNotEmpty) {
      setState(() {
        selectedImage = null;
      });
      await viewModel.sendChat(image: base64Image, message: message);
      setState(() {
        base64Image = null;
      });
    }
    // if (base64Image != null) {
    //   setState(() {
    //     selectedImage = null;
    //     base64Image = null;
    //   });
    //   await viewModel.sendChat(image: base64Image, message: message);
    // }
    await fetchChat();
  }

  Widget buildQuickActions() {
    final List<String> allQuickQuestions = [
      "Saya gatal-gatal di tangan, kenapa ya?",
      "Saya punya bintik-bintik di wajah, normal?",
      "Kulit saya menghitam setelah luka, apa solusinya?",
      "Apa penyebab kulit mengelupas di ujung jari?",
      "Apakah gatal-gatal bisa disebabkan oleh stres?",
      "Clea, dari mana kamu mendapatkan informasi medis?",
    ];

    // Contoh penggunaan:
    final List<String> quickQuestions = allQuickQuestions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "Selamat datang di SkinCheck",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Pilih salah satu pertanyaan di bawah ini untuk memulai.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  quickQuestions.map((question) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isOnline ? () => handleSend(question) : null,
                        child: Text(question),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImagePreview() {
    if (selectedImage == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                selectedImage!,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: -10,
            top: -10,
            child: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () {
                setState(() {
                  selectedImage = null;
                  base64Image = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed:
                      isOnline ? () => pickImage(ImageSource.gallery) : null,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed:
                      isOnline ? () => pickImage(ImageSource.camera) : null,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildImagePreview(),
                      TextFormField(
                        controller: messageController,
                        enabled: isOnline,
                        maxLines: null,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText:
                              isOnline ? "Tulis pesan..." : "Tidak ada koneksi",
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap:
                      isOnline
                          ? () => handleSend(messageController.text)
                          : null,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isOnline
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
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
          ],
        ),
      ),
    );
  }

  Widget buildChatList() {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      children:
          chat.map((ch) {
            return ChatItem(
              image: ch.image_base64,
              message: ch.message ?? "",
              isSender: ch.sender == "user",
              date: ch.created_at ?? "",
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(chats: chats),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset("assets/images/logo-home.png", height: 30),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed:
                isOnline
                    ? () => Navigator.pushReplacementNamed(context, "/chat")
                    : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: chat.isEmpty ? buildQuickActions() : buildChatList(),
            ),
            buildChatInput(),
          ],
        ),
      ),
    );
  }
}
