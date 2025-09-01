import 'package:flutter/material.dart';
import 'package:healthai/features/notifications/data/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  void addNotification(NotificationModel notification) {
    _notifications.add(notification);
    notifyListeners();
    // هنا يمكن إضافة حفظ البيانات في التخزين المحلي
  }

  void removeNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    notifyListeners();
  }
}
