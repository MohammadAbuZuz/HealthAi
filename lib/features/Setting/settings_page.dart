import 'package:flutter/material.dart';
import 'package:healthai/features/Setting/settings_item.dart';
import 'package:healthai/features/Setting/settings_section.dart';

import '../../services/responsive.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.responsiveValue(
      context,
      mobile: 12,
      tablet: 16,
      desktop: 24,
    );
    final appBarFontSize = Responsive.fontSize(
      context,
      mobile: 20,
      tablet: 24,
      desktop: 28,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'HealthAI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: appBarFontSize,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF769DAD),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: const [
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
