// features/notifications/presentation/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:healthai/features/notifications/presentation/widgets/notification_form.dart';
import 'package:healthai/features/notifications/provider/notification_provider.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'إضافة تنبيه جديد',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF769DAD),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<NotificationProvider>(
            builder: (context, provider, child) {
              return NotificationForm(onSave: provider.addNotification);
            },
          ),
        ),
      ),
    );
  }
}
