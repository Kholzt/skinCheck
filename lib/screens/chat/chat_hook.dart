import 'package:flutter/material.dart';
import 'package:skin_chek/data/models/ChatItemModel.dart';
import 'package:skin_chek/data/models/ChatModel.dart';
import 'package:skin_chek/utils/api_service.dart';
import 'package:uuid/uuid.dart';

class ChatHook {
  BuildContext? context;
  final ScrollController scrollController = ScrollController();
  String chatId; // properti chat ID
  ChatHook({String? chatId}) : chatId = chatId ?? const Uuid().v4();

  void setChatId(String? id) {
    chatId = id ?? const Uuid().v4();
  }

  void setContext(BuildContext ctx) {
    context = ctx;
  }

  String? messageValidator(val) {
    if (val == null || val.isEmpty) return "Pesan wajib diisi";
    return null;
  }

  Future<List<ChatItemModel>> getChat() async {
    print("dari hook: " + chatId);
    final chat = await ApiService.getChatHistory(chatId: chatId);
    return chat.map((map) => ChatItemModel.fromMap(map)).toList();
  }

  Future<List<ChatModel>> getAllChat() async {
    final chat = await ApiService.getAllChat();
    return chat.map((map) => ChatModel.fromMap(map)).toList();
  }

  Future<void> sendChat({String? message, String? image}) async {
    scrollToBottom();
    final now = DateTime.now(); // Waktu lokal perangkat
    final timestamp = now.toIso8601String();
    final chat = await ApiService.sendChat(
      message: message,
      chatId: chatId,
      timestamp: timestamp,
      imageBase64: image,
    );
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
