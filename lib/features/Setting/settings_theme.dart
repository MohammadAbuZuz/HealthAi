import 'package:flutter/material.dart';

//ثيم وألوان الإعدادات
class SettingsTheme {
  static const Color primaryColor = Color(0xFF769DAD);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333);
  static const Color secondaryTextColor = Color(0xFF666666);
  static const Color borderColor = Color(0xFFEEEEEE);

  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static const TextStyle itemTitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle itemValueStyle = TextStyle(
    color: secondaryTextColor,
    fontSize: 14,
  );

  static const BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(
        color: Color(0x11000000),
        spreadRadius: 4,
        blurRadius: 7,
        offset: Offset(0, 2),
      ),
    ],
  );
}
