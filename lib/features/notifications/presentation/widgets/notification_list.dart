// features/notifications/presentation/widgets/notification_list.dart
import 'package:flutter/material.dart';
import 'package:healthai/features/notifications/data/models/notification_model.dart';
import 'package:healthai/features/notifications/provider/notification_provider.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    final notifications = provider.notifications;

    if (notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off, size: 40, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'لا توجد تنبيهات مضافة بعد',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'اضغط على زر + لإضافة تنبيه جديد',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true, // إضافة هذه السطر
      physics: const NeverScrollableScrollPhysics(), // إضافة هذه السطر
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(context, notification, provider);
      },
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationModel notification,
    NotificationProvider provider,
  ) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(context);
      },
      onDismissed: (direction) {
        provider.removeNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حذف التنبيه: ${notification.text}'),
            backgroundColor: Colors.red,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF769DAD),
            child: Icon(
              notification.isDaily ? Icons.repeat : Icons.notifications,
              color: Colors.white,
            ),
          ),
          title: Text(
            notification.text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الوقت: ${_formatTimeOfDay(notification.time)}'),
              Text('التكرار: ${notification.isDaily ? 'يومي' : 'مرة واحدة'}'),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteDialog(context, notification, provider);
            },
          ),
          onTap: () {
            // يمكنك إضافة functionality للتعديل على التنبيه هنا لاحقاً
            _showNotificationDetails(context, notification);
          },
        ),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من أنك تريد حذف هذا التنبيه؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showDeleteDialog(
    BuildContext context,
    NotificationModel notification,
    NotificationProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التنبيه'),
        content: Text('هل تريد حذف التنبيه "${notification.text}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              provider.removeNotification(notification.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف التنبيه: ${notification.text}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetails(
    BuildContext context,
    NotificationModel notification,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل التنبيه'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('النص: ${notification.text}'),
            const SizedBox(height: 8),
            Text('الوقت: ${_formatTimeOfDay(notification.time)}'),
            const SizedBox(height: 8),
            Text('التكرار: ${notification.isDaily ? 'يومي' : 'مرة واحدة'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}
