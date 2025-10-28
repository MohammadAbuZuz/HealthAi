import 'package:flutter/material.dart';
import 'package:healthai/core/widget/custom_text_field.dart';

import '../../../../services/responsive.dart'; // تأكد من مسار كلاس Responsive

class NotificationTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  const NotificationTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.responsiveValue(
      context,
      mobile: 12,
      tablet: 16,
      desktop: 20,
    );
    final verticalPadding = Responsive.responsiveValue(
      context,
      mobile: 8,
      tablet: 12,
      desktop: 16,
    );
    final fontSize = Responsive.fontSize(
      context,
      mobile: 14,
      tablet: 16,
      desktop: 18,
    );
    final labelFontSize = Responsive.fontSize(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );

    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: verticalPadding),
            CustomTextField(
              controller: controller,
              obscureText: obscureText,
              hintText: hintText,
              iconPath: '',
            ),
          ],
        ),
      ),
    );
  }
}
