import 'package:flutter/material.dart';
import 'package:skin_chek/screens/chat/ChatItem.dart';
import 'package:skin_chek/screens/chat/Drawer.dart';
import 'package:skin_chek/screens/chat/chat_hook.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ChatHook viewModel = ChatHook();
  final _formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> chat = [];

  @override
  void initState() {
    super.initState();
    viewModel.setContext(context);
    fetchChat();
  }

  Future<void> fetchChat() async {
    try {
      final chats = await viewModel.getChat();
      setState(() {
        chat = chats;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    } catch (e) {
      debugPrint("Error loading chat: $e");
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
    if (message.trim().isEmpty) return;

    setState(() {
      chat.add({
        "message": message,
        "sender": "user",
        "timestamp": DateTime.now().toIso8601String(),
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

    messageController.clear();
    await viewModel.sendChat(message: message);
    await fetchChat();
  }

  Widget buildQuickActions() {
    final List<String> quickQuestions = [
      "Saya gatal-gatal di tangan, kenapa ya?",
      "Kulit saya merah dan perih, apakah alergi?",
      "Saya punya bintik-bintik di wajah, normal?",
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "Belum ada konsultasi",
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
                  return ElevatedButton(
                    onPressed: () => handleSend(question),
                    child: Text(question),
                  );
                }).toList(),
          ),
        ],
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
              message: ch['message'],
              isSender: ch['sender'] == "user",
              date: ch['timestamp'],
            );
          }).toList(),
    );
  }

  Widget buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {
                // TODO: handle attachme
              },
            ),
            Expanded(
              child: TextFormField(
                controller: messageController,
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
            const SizedBox(width: 10),
            InkWell(
              onTap: () => handleSend(messageController.text),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset("assets/images/logo-home.png", height: 30),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/chat");
            },
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
