import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/models/ai_template.dart';
import 'ai_input_form_screen.dart';

class AIHomeScreen extends StatelessWidget {
  const AIHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cards = [
      {
        'template': allTemplates[0],
        'color': Colors.greenAccent.shade100,
        'icon': LucideIcons.dumbbell,
      },
      {
        'template': allTemplates[1],
        'color': Colors.orangeAccent.shade100,
        'icon': LucideIcons.activity,
      },
      {
        'template': allTemplates[2],
        'color': Colors.pinkAccent.shade100,
        'icon': LucideIcons.scale,
      },
      {
        'template': allTemplates[3],
        'color': Colors.lightBlueAccent.shade100,
        'icon': LucideIcons.flag,
      },
      {
        'template': allTemplates[4],
        'color': Colors.purpleAccent.shade100,
        'icon': LucideIcons.heart,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '💡 الاستشارات الذكية',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor:  const Color(0xFF769DAD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final item = cards[index];
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Get.to(() => AIInputFormScreen(template: item['template'])),
              child: Container(
                decoration: BoxDecoration(
                  color: item['color'],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'],
                      size: 50,
                      color: Colors.teal.shade700,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['template'].title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
