// features/notifications/presentation/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:healthai/features/notifications/presentation/widgets/notification_form.dart';
import 'package:healthai/features/notifications/presentation/widgets/notification_list.dart';
import 'package:healthai/features/notifications/provider/notification_provider.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // تحميل التنبيهات عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إدارة التنبيهات',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF769DAD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'التنبيهات الحالية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            NotificationList(),
            const SizedBox(height: 24),
            const Text(
              'إضافة تنبيه جديد',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            NotificationForm(
              onSave: (notification) {
                Provider.of<NotificationProvider>(
                  context,
                  listen: false,
                ).addNotification(notification);
              },
            ),
          ],
        ),
      ),
    );
  }
}
