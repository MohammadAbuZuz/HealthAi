class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  // تحويل إلى Map للتخزين
  Map<String, dynamic> toMap() {
    return {'text': text, 'isUser': isUser, '': timestamp.toIso8601String()};
  }

  // إنشاء من Map
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'],
      isUser: map['isUser'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
