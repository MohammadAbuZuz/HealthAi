import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/models/ai_template.dart';

class GeminiService {
  // المفتاح
  static const String _apiKey = 'AIzaSyC3xLcmxGuwI94IAPwQviy5zt-fndsVjY8';

  /// دالة عامة للرسائل النصية
  static Future<String> sendMessage(String prompt) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash', // ✅ تم تحديث النموذج
        apiKey: _apiKey,
      );

      final response = await model.generateContent([Content.text(prompt)]);

      return response.text ?? 'عذراً، لم أتمكن من توليد رد. حاول مرة أخرى.';
    } catch (e) {
      print('Error calling Gemini API: **************************************** $e');
      return 'حدث خطأ في الاتصال بالمساعد. يرجى المحاولة لاحقاً.';
    }
  }

  /// دالة مخصصة للاستشارات الطبية باستخدام Templates
  static Future<String> getAIResponse(AITemplate template, Map<String, String> inputs) async {
    final prompt = """
أنت مساعد طبي مختص في ${template.title}.
اتبع طريقة التفكير التالية:
${template.reasoningSteps}

بيانات المستخدم:
${inputs.entries.map((e) => "${e.key}: ${e.value}").join("\n")}

أجب وفق التنسيق التالي:
${template.outputFormat}
""";

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash', // ✅ تم تحديث النموذج هنا أيضًا
        apiKey: _apiKey,
      );

      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? "تعذر الحصول على إجابة.";
    } catch (e) {
      print('GeminiService.getAIResponse Error: $e');
      return 'حدث خطأ أثناء معالجة الاستشارة.';
    }
  }

  /// نسخة Mock للتجربة بدون API
  static Future<String> sendMessageMock(String prompt) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'هذا رد تجريبي على: "$prompt"';
  }
}
