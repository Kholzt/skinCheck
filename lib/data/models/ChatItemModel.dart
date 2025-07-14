class ChatItemModel {
  String? message;
  String? image_base64;
  bool has_image;
  String created_at;
  String sender;

  ChatItemModel({
    this.message,
    this.image_base64,
    this.has_image = false,
    required this.created_at,
    required this.sender,
  });

  // Factory constructor untuk membuat instance dari Map
  factory ChatItemModel.fromMap(Map<dynamic, dynamic> map) {
    return ChatItemModel(
      message: map['message'],
      image_base64: map['image_base64'],
      has_image: map['has_image'] ?? false,
      sender: map['sender'] ?? '',
      created_at: map['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'image_base64': image_base64,
      'has_image': has_image,
      'sender': sender,
      'created_at': created_at,
    };
  }
}
