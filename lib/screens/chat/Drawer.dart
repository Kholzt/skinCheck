import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_chek/data/models/ChatModel.dart';
import 'package:skin_chek/main.dart';
import 'package:skin_chek/screens/chat/Chat.dart';
import 'package:skin_chek/screens/chat/chat_hook.dart';
import 'package:skin_chek/utils/google_service.dart';

class AppDrawer extends StatefulWidget {
  final List<ChatModel> chats;
  const AppDrawer({super.key, required this.chats});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final ChatHook viewModel = ChatHook();
  late List<ChatModel> chat;
  bool isOnline = isOnlineNotifier.value;

  @override
  void initState() {
    super.initState();
    chat = widget.chats;

    isOnlineNotifier.addListener(() {
      setState(() {
        isOnline = isOnlineNotifier.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = GoogleAuthService().getUser();

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // ✅ HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                // color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user?.photoURL ?? ""),
                    radius: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? "Anonym",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user?.email ?? "",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ✅ CHAT BARU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                onPressed:
                    isOnline
                        ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Chat(),
                            ),
                          );
                        }
                        : null,
                icon: const Icon(Icons.add),
                label: const Text("Chat Baru"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size.fromHeight(45),
                ),
              ),
            ),

            // ✅ LABEL HISTORY
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 12, bottom: 4),
              child: Row(
                children: const [
                  Icon(Icons.history, color: Colors.grey, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Riwayat Chat",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // ✅ LIST CHAT HISTORY
            Expanded(child: buildHistory(chat)),

            // ✅ LOGOUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ListTile(
                tileColor: Colors.red.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () async {
                  await GoogleAuthService().signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ LIST HISTORY CHAT
Widget buildHistory(List<ChatModel> chats) {
  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    itemCount: chats.length,
    itemBuilder: (context, index) {
      final ch = chats[index];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Material(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          // elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Chat(chatId: ch.chat_id),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ch.title ?? "-",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
