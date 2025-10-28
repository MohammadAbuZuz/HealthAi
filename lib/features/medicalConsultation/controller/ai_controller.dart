import 'package:get/get.dart';
import '../../../core/models/ai_template.dart';
import '../../../services/gemini_service.dart';



class AIController extends GetxController {
  final service = GeminiService();
  var loading = false.obs;
  var aiResponse = ''.obs;

  Future<void> analyze(AITemplate template, Map<String, String> inputs) async {
    loading.value = true;
    aiResponse.value = await GeminiService.getAIResponse(template, inputs);
    loading.value = false;
  }
}
