import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  //  المفتاح
  static const String _apiKey = 'AIzaSyCaxfoT4tJHKcFNmMs0Vvnkc_bMzkefGUo';

  static Future<String> sendMessage(String prompt) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash', //   الموديل
        apiKey: _apiKey,
      );

      final response = await model.generateContent([Content.text(prompt)]);

      return response.text ?? 'عذراً، لم أتمكن من توليد رد. حاول مرة أخرى.';
    } catch (e) {
      print('Error calling Gemini API: $e');
      return 'حدث خطأ في الاتصال بالمساعد. يرجى المحاولة لاحقاً.';
    }
  }
}
