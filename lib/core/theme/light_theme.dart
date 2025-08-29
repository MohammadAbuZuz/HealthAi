import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    textTheme: TextTheme(
        bodySmall: TextStyle(color: Color(0xFF515151), fontSize: 14),
        labelSmall: TextStyle(color: Color(0xFF515151), fontSize: 14),
        titleSmall: TextStyle(color: Color(0xFF515151), fontSize: 14),
        titleMedium: TextStyle(
            color: Color(0xFF000000),
            fontSize: 16,
            fontWeight: FontWeight.w800),
        titleLarge: TextStyle(
            color: Color(0xFF000000),
            fontSize: 24,
            fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: Color(0xFF515151), fontSize: 14),
        displayLarge: TextStyle()),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.black),
    )));
