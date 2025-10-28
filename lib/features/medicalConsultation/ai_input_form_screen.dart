import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/models/ai_template.dart';
import 'controller/ai_controller.dart';
import 'view/ai_result_screen.dart';

class AIInputFormScreen extends StatefulWidget {
  final AITemplate template;
  const AIInputFormScreen({required this.template, super.key});

  @override
  State<AIInputFormScreen> createState() => _AIInputFormScreenState();
}

class _AIInputFormScreenState extends State<AIInputFormScreen> {
  final controller = Get.put(AIController());
  final Map<String, String> inputs = {};

  IconData getFieldIcon(String field) {
    if (field.contains('العمر')) return LucideIcons.calendar;
    if (field.contains('الوزن')) return LucideIcons.scale;
    if (field.contains('الطول')) return LucideIcons.arrowUp;
    if (field.contains('الجنس')) return LucideIcons.user;
    if (field.contains('النشاط')) return LucideIcons.activity;
    if (field.contains('بشرة') || field.contains('جلد')) return LucideIcons.heart;
    if (field.contains('شعر')) return LucideIcons.sparkles;
    return LucideIcons.edit3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.template.title,style: TextStyle(color: Colors.white),),
        backgroundColor:  const Color(0xFF769DAD),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            ...widget.template.inputFields.map((field) => Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(getFieldIcon(field), color:  const Color(0xFF769DAD)),
                  labelText: field,
                  labelStyle: const TextStyle(fontSize: 16),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                onChanged: (v) => inputs[field] = v,
              ),
            )),
            const SizedBox(height: 24),

            // زر التحليل
            Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: controller.loading.value
                    ? Colors.teal.withOpacity(0.5)
                    :  const Color(0xFF769DAD),
              ),
              child: ElevatedButton.icon(
                onPressed: controller.loading.value
                    ? null
                    : () async {
                  await controller.analyze(widget.template, inputs);
                  Get.to(() => AIResultScreen(result: controller.aiResponse.value));
                },
                icon: controller.loading.value
                    ? const CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2)
                    : const Icon(LucideIcons.brain, color: Colors.white),
                label: Text(
                  controller.loading.value
                      ? 'جاري التحليل...'
                      : 'ابدأ التحليل',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }
}
