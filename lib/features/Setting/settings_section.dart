import 'package:flutter/material.dart';

import 'settings_theme.dart';

//مكون لقسم الإعدادات
class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.only(bottom: 24),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: SettingsTheme.titleStyle),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
