import 'package:flutter/material.dart';
import 'package:skin_chek/utils/api_service.dart';
import 'package:uuid/uuid.dart';

class ChatHook {
  BuildContext? context;
  final ScrollController scrollController = ScrollController();
  final String chatId; // properti chat ID

  ChatHook({String? chatId}) : chatId = chatId ?? const Uuid().v4();

  setContext(BuildContext context) {
    context = context;
  }

  String? messageValidator(val) {
    if (val == null || val.isEmpty) return "Pesan wajib diisi";
    return null;
  }

  Future<List<Map<String, dynamic>>> getChat() async {
    final chat = await ApiService.getChatHistory(chatId: chatId);
    return List<Map<String, dynamic>>.from(chat);
  }

  Future<void> sendChat({String? message}) async {
    scrollToBottom();
    final chat = await ApiService.sendChat(message: message, chatId: chatId);
    print(chat);
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  void dispose() {
    scrollController.dispose();
  }
}
