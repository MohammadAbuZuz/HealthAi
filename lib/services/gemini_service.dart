import 'package:google_generative_ai/google_generative_ai.dart'; // هذا الاستيراد ضروري

class GeminiService {
  static const String _apiKey =
      'your_gemini_api_key_here'; // سيتم استبداله لاحقاً

  // إرسال رسالة إلى Gemini API
  static Future<String> sendMessage(String prompt) async {
    try {
      final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);

      final response = await model.generateContent([Content.text(prompt)]);

      return response.text ?? 'عذراً، لم أتمكن من توليد رد. حاول مرة أخرى.';
    } catch (e) {
      print('Error calling Gemini API: $e');
      return 'حدث خطأ في الاتصال بالمساعد. يرجى المحاولة لاحقاً.';
    }
  }
}
