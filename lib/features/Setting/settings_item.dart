import 'package:flutter/material.dart';
import 'package:healthai/features/Setting/settings_theme.dart';

import '../../services/responsive.dart';

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
    final padding = Responsive.responsiveValue(
      context,
      mobile: 12,
      tablet: 16,
      desktop: 20,
    );
    final fontSize = Responsive.fontSize(
      context,
      mobile: 14,
      tablet: 16,
      desktop: 18,
    );
    final iconSize = Responsive.responsiveValue(
      context,
      mobile: 20,
      tablet: 24,
      desktop: 28,
    );

    return Container(
      margin: EdgeInsets.only(bottom: padding),
      decoration: SettingsTheme.cardDecoration,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: padding / 2,
        ),
        leading: Icon(icon, color: SettingsTheme.primaryColor, size: iconSize),
        title: Text(
          title,
          style: SettingsTheme.itemTitleStyle.copyWith(fontSize: fontSize),
        ),
        trailing: _buildTrailing(context),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    final fontSize = Responsive.fontSize(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );
    final iconSize = Responsive.responsiveValue(
      context,
      mobile: 16,
      tablet: 20,
      desktop: 24,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (value != null)
          Text(
            value!,
            style: SettingsTheme.itemValueStyle.copyWith(fontSize: fontSize),
          ),
        if (hasArrow)
          Icon(Icons.arrow_left, color: Colors.grey[500], size: iconSize),
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
