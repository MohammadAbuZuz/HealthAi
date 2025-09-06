import 'package:flutter/material.dart';

import '../../services/responsive.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Responsive.responsiveValue(
            context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            height: Responsive.responsiveValue(
              context,
              mobile: 48,
              tablet: 55,
              desktop: 65,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8EDDFF), // الأزرق الفاتح
                  Color(0xFF769DAD), // الأزرق الغامق
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(
                Responsive.responsiveValue(
                  context,
                  mobile: 10,
                  tablet: 14,
                  desktop: 18,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: Responsive.fontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
