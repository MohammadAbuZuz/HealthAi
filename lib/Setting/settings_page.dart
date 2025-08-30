import 'package:flutter/material.dart';
import 'package:healthai/Setting/settings_item.dart';

import 'settings_section.dart';

//الصفحة الرئيسية للإعدادات
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HealthAI',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF769DAD),
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SettingsSection(
              title: 'الإعدادات',
              children: [
                SettingsItem(
                  title: 'اللغة',
                  value: 'العربية',
                  icon: Icons.language,
                  hasArrow: true,
                ),
                SettingsItem(
                  title: 'الإشعارات',
                  value: 'تنشيط',
                  icon: Icons.notifications,
                  hasSwitch: true,
                  switchValue: true,
                ),
              ],
            ),
            SettingsSection(
              title: 'المعلومات',
              children: [
                SettingsItem(
                  title: 'سياسة الخصوصية',
                  icon: Icons.privacy_tip,
                  hasArrow: true,
                ),
                SettingsItem(
                  title: 'حول تطبيق HealthAI',
                  icon: Icons.info,
                  hasArrow: true,
                ),
              ],
            ),
            SettingsSection(
              title: 'الدعم',
              children: [
                SettingsItem(
                  title: 'تقييم التطبيق',
                  icon: Icons.star,
                  hasArrow: true,
                ),
                SettingsItem(
                  title: 'التواصل مع الدعم',
                  icon: Icons.support_agent,
                  hasArrow: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
