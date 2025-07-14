class ChatModel {
  String chat_id;
  String title;
  String created_at;

  ChatModel({
    required this.chat_id,
    required this.title,
    required this.created_at,
  });

  // Factory constructor untuk membuat instance dari Map
  factory ChatModel.fromMap(Map<dynamic, dynamic> map) {
    return ChatModel(
      chat_id: map['chat_id'],
      title: map['title'],
      created_at: map['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'chat_id': chat_id, 'title': title, 'created_at': created_at};
  }
}
