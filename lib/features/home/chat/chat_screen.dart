import 'package:flutter/material.dart';
import 'package:healthai/services/gemini_service.dart';
import 'package:healthai/services/local_storage_service.dart';
import 'package:healthai/services/prompt_engineer.dart';

import 'chat_bubble.dart';
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  Map<String, dynamic>? _currentUserData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // دالة لتحميل بيانات المستخدم الحالي من Local Storage
  Future<void> _loadUserData() async {
    try {
      final userData = await LocalStorageService.getCurrentUser();
      setState(() {
        _currentUserData = userData;
      });

      // إضافة رسالة ترحيبية مخصصة للمستخدم
      if (_messages.isEmpty) {
        _addBotMessage(_generateWelcomeMessage());
      }
    } catch (e) {
      print('خطأ في تحميل بيانات المستخدم: $e');
    }
  }

  // توليد رسالة ترحيبية مخصصة بناءً على بيانات المستخدم
  String _generateWelcomeMessage() {
    if (_currentUserData == null) {
      return 'مرحباً! كيف يمكنني مساعدتك اليوم؟';
    }

    final name = _currentUserData!['name'] ?? 'صديقي';
    final goal = _currentUserData!['goal'] ?? 'تحسين صحتك';

    return 'مرحباً $name! أنا مساعدك الصحي في HealthAI. '
        'أنا هنا لمساعدتك في تحقيق هدفك: $goal. '
        'اسألني عن أي شيء يتعلق بالتغذية، الرياضة، أو الصحة العامة.';
  }

  // دالة إرسال الرسالة
  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _isLoading) return;

    // إضافة رسالة المستخدم إلى القائمة
    _addUserMessage(messageText);
    _messageController.clear();

    setState(() => _isLoading = true);

    try {
      // إنشاء برومبت مخصص باستخدام بيانات المستخدم
      final prompt = PromptEngineer.createHealthPrompt(
        userMessage: messageText,
        userData: _currentUserData,
      );

      // إرسال الطلب إلى Gemini API
      final response = await GeminiService.sendMessage(prompt);

      // إضافة رد المساعد إلى القائمة
      _addBotMessage(response);
    } catch (e) {
      _addBotMessage('عذراً، حدث خطأ في الاتصال. حاول مرة أخرى.');
      print('Error sending message: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // إضافة رسالة المستخدم
  void _addUserMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
    });
  }

  // إضافة رسالة البوت
  void _addBotMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: false, timestamp: DateTime.now()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تغذي صحية"),
        centerTitle: true,
        backgroundColor: const Color(0xFF769DAD),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // منطقة الدردشة
          Expanded(child: _buildChatList()),

          // منطقة إدخال الرسالة
          _buildMessageInput(),
        ],
      ),
    );
  }

  // بناء قائمة الدردشة
  Widget _buildChatList() {
    if (_messages.isEmpty) {
      return const Center(
        child: Text(
          "ابدأ محادثة مع المساعد الصحي...",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[_messages.length - 1 - index];
        return ChatBubble(message: message);
      },
    );
  }

  // بناء واجهة إدخال الرسالة
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          // حقل إدخال النص
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "اكتب رسالتك هنا...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
              enabled: !_isLoading,
            ),
          ),

          const SizedBox(width: 8),

          // زر الإرسال
          Container(
            decoration: BoxDecoration(
              color: _isLoading ? Colors.grey : const Color(0xFF8EDDFF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 2,
                    )
                  : const Icon(Icons.send, color: Colors.white),
              onPressed: _isLoading ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
