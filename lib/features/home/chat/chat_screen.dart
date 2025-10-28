import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:healthai/services/local_storage_service.dart';
import 'package:healthai/services/prompt_engineer.dart';
import '../../../services/gemini_service.dart';
import 'chat_bubble.dart';
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isTyping = false;
  String _currentTypingText = '';
  int _typingIndex = 0;
  Map<String, dynamic>? _currentUserData;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadChatHistory();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  // تحميل بيانات المستخدم وسجل الدردشة
  Future<void> _loadUserData() async {
    try {
      final userData = await LocalStorageService.getCurrentUser();
      setState(() {
        _currentUserData = userData;
      });

      if (_messages.isEmpty) {
        _addBotMessage(_generateWelcomeMessage());
      }
    } catch (e) {
      print('خطأ في تحميل بيانات المستخدم: $e');
    }
  }

  // تحميل سجل الدردشة من التخزين المحلي
  Future<void> _loadChatHistory() async {
    try {
      final chatHistory = await LocalStorageService.getUserData('chat_history');
      if (chatHistory.isNotEmpty) {
        setState(() {
          _messages = chatHistory
              .map(
                (data) => ChatMessage.fromMap(Map<String, dynamic>.from(data)),
              )
              .toList();
        });
      }
    } catch (e) {
      print('خطأ في تحميل سجل الدردشة: $e');
    }
  }

  // حفظ سجل الدردشة في التخزين المحلي
  Future<void> _saveChatHistory() async {
    try {
      final chatData = _messages.map((message) => message.toMap()).toList();
      await LocalStorageService.saveUserData('chat_history', chatData);
    } catch (e) {
      print('خطأ في حفظ سجل الدردشة: $e');
    }
  }

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

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _isLoading || _isTyping) return;

    _addUserMessage(messageText);
    _messageController.clear();

    setState(() => _isLoading = true);

    try {
      final prompt = PromptEngineer.createHealthPrompt(
        userMessage: messageText,
        userData: _currentUserData,
      );

      final response = await GeminiService.sendMessage(prompt);
      _startTypingAnimation(response);
    } catch (e) {
      _addBotMessage('عذراً، حدث خطأ في الاتصال. حاول مرة أخرى.');
      print('Error sending message: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
    });
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: false, timestamp: DateTime.now()),
      );
    });
    _saveChatHistory();
  }

  void _startTypingAnimation(String fullText) {
    _typingTimer?.cancel();

    setState(() {
      _isTyping = true;
      _currentTypingText = fullText;
      _typingIndex = 0;
    });

    final random = Random();
    _typingTimer = Timer.periodic(
      Duration(milliseconds: random.nextInt(50) + 20),
      (Timer timer) {
        if (_typingIndex < fullText.length) {
          setState(() {
            _typingIndex++;
          });
        } else {
          timer.cancel();
          setState(() {
            _isTyping = false;
          });
          _addBotMessage(fullText);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("صحة ذكية"),
        centerTitle: true,
        backgroundColor: const Color(0xFF769DAD),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(child: _buildChatList()),
          if (_isTyping) _buildTypingIndicator(), // نقلنا المؤشر هنا
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    if (_messages.isEmpty && !_isTyping) {
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
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isTyping && index == 0) {
          // عرض الرسالة التي لا تزال تكتب
          return ChatBubble(
            message: ChatMessage(
              text: _currentTypingText.substring(0, _typingIndex),
              isUser: false,
              timestamp: DateTime.now(),
            ),
            userImage: _currentUserData?['profileImage'],
          );
        }

        // الرسائل العادية
        final messageIndex = index - (_isTyping ? 1 : 0);
        final message = _messages[_messages.length - 1 - messageIndex];
        return ChatBubble(
          message: message,
          userImage: _currentUserData?['profileImage'],
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
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
              enabled: !_isLoading && !_isTyping,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: (_isLoading || _isTyping)
                  ? Colors.grey
                  : const Color(0xFF8EDDFF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 2,
                    )
                  : const Icon(Icons.send, color: Colors.white),
              onPressed: (_isLoading || _isTyping) ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // محاذاة لليسار
        children: [
          // الأيقونة الدوارة على اليسار
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Color(0xFF769DAD)),
            ),
          ),
          const SizedBox(width: 12),
          // النص بجانب الأيقونة
          Text(
            'البوت يكتب الآن...',
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
