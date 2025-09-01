import 'package:flutter/material.dart';
import 'package:healthai/features/Setting/settings_theme.dart';

//مكون لعنصر الإعداد الفردي
class SettingsItem extends StatelessWidget {
  final String title;
  final String? value;
  final IconData icon;
  final bool hasArrow;
  final bool hasSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.title,
    this.value,
    required this.icon,
    this.hasArrow = false,
    this.hasSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: SettingsTheme.cardDecoration,
      child: ListTile(
        leading: Icon(icon, color: SettingsTheme.primaryColor),
        title: Text(
          title,
          style: SettingsTheme.itemTitleStyle,
          textDirection: TextDirection.rtl,
        ),
        trailing: _buildTrailing(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (value != null)
          Text(
            value!,
            style: SettingsTheme.itemValueStyle,
            textDirection: TextDirection.rtl,
          ),
        if (hasArrow) Icon(Icons.arrow_left, color: Colors.grey[500], size: 24),
        if (hasSwitch)
          Switch(
            value: switchValue,
            onChanged: onSwitchChanged,
            activeColor: SettingsTheme.primaryColor,
          ),
      ],
    );
  }
}
