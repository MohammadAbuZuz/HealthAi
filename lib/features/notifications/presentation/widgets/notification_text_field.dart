// features/notifications/presentation/widgets/notification_text_field.dart
import 'package:flutter/material.dart';
import 'package:healthai/core/widget/custom_text_field.dart';

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
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
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
