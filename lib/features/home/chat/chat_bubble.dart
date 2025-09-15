import 'package:flutter/material.dart';

import 'chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final String? userImage;

  const ChatBubble({super.key, required this.message, this.userImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isUser) _buildBotAvatar(),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? const Color(0xFF8EDDFF)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (message.isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  // بناء صورة المستخدم
  Widget _buildUserAvatar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: CircleAvatar(
        backgroundColor: message.isUser
            ? const Color(0xFF769DAD)
            : Colors.grey.shade300,
        child: Icon(
          message.isUser ? Icons.person : Icons.health_and_safety,
          color: message.isUser ? Colors.white : Colors.grey,
        ),
      ),
    );
  }

  // بناء أيقونة البوت
  Widget _buildBotAvatar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: const CircleAvatar(
        radius: 20,
        backgroundColor: Color(0xFF769DAD),
        child: Icon(Icons.health_and_safety, size: 20, color: Colors.white),
      ),
    );
  }
}
