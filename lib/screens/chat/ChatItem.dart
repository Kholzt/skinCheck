import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class ChatItem extends StatelessWidget {
  final String message;
  final String date;
  final bool isSender;

  const ChatItem({
    super.key,
    required this.message,
    required this.isSender,
    required this.date,
  });

  String _formatDate(String dateStr) {
    try {
      final timestamp = DateTime.parse(
        dateStr,
      ); // Format: "2025-07-13T20:20:00"
      return DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(timestamp);
    } catch (s) {
      print(s);
      return dateStr; // fallback jika parsing gagal
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isSender ? Theme.of(context).primaryColor : Colors.grey.shade300;
    final textColor = isSender ? Colors.white : Colors.black;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(12),
                bottomRight: const Radius.circular(12),
                topLeft: isSender ? const Radius.circular(12) : Radius.zero,
                topRight: isSender ? Radius.zero : const Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdownBody(
                  data: message,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(color: textColor, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment:
                      isSender ? Alignment.bottomRight : Alignment.bottomLeft,
                  child: Text(
                    _formatDate(date),
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
