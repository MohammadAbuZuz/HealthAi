// features/notifications/provider/notification_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthai/features/notifications/data/models/notification_model.dart';
import 'package:healthai/features/notifications/utils/notification_utils.dart';
import 'package:healthai/services/local_storage_service.dart'; // أضف هذا الاستيراد
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  String? _currentUserEmail; // لتخزين البريد الإلكتروني للمستخدم الحالي

  Future<void> addNotification(NotificationModel notification) async {
    _notifications.add(notification);

    // جدولة الإشعار
    await NotificationUtils.scheduleNotification(
      id: int.parse(notification.id),
      title: 'تذكير',
      body: notification.text,
      time: notification.time,
      isDaily: notification.isDaily,
      payload: notification.id,
    );

    notifyListeners();
    await _saveToStorage();
  }

  Future<void> removeNotification(String id) async {
    _notifications.removeWhere((notification) => notification.id == id);
    await NotificationUtils.cancelNotification(int.parse(id));
    notifyListeners();
    await _saveToStorage();
  }

  Future<void> loadNotifications() async {
    // الحصول على المستخدم الحالي أولاً
    final currentUser = await LocalStorageService.getCurrentUser();
    _currentUserEmail = currentUser?['email']; // حفظ البريد الإلكتروني

    if (_currentUserEmail == null) {
      print('لا يوجد مستخدم حالي لتحديد التنبيهات');
      _notifications.clear();
      notifyListeners();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    // استخدام مفتاح فريد لكل مستخدم
    final notificationsKey = 'notifications_$_currentUserEmail';
    final notificationsJson = prefs.getStringList(notificationsKey);

    _notifications.clear();

    if (notificationsJson != null && notificationsJson.isNotEmpty) {
      for (final json in notificationsJson) {
        try {
          final Map<String, dynamic> notificationMap = jsonDecode(json);
          final notification = NotificationModel.fromJson(notificationMap);
          _notifications.add(notification);
        } catch (e) {
          print('Error parsing notification: $e');
        }
      }
      print(
        'تم تحميل ${_notifications.length} تنبيهات للمستخدم: $_currentUserEmail',
      );
    } else {
      // لا نضيف بيانات افتراضية هنا لأنها ستظهر لكل مستخدم جديد
      print('لا توجد تنبيهات محفوظة للمستخدم: $_currentUserEmail');
    }

    notifyListeners();
  }

  // حفظ التنبيهات في التخزين المحلي بمفتاح فريد
  Future<void> _saveToStorage() async {
    if (_currentUserEmail == null) {
      print('لا يمكن الحفظ بدون مستخدم حالي');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final notificationsKey = 'notifications_$_currentUserEmail';
    final notificationsJson = _notifications
        .map((n) => jsonEncode(n.toJson()))
        .toList();

    await prefs.setStringList(notificationsKey, notificationsJson);
    print(
      'تم حفظ ${_notifications.length} تنبيهات للمستخدم: $_currentUserEmail',
    );
  }

  // دالة جديدة لمسح التنبيهات من الذاكرة عند تسجيل الخروج
  void clearNotifications() {
    _notifications.clear();
    _currentUserEmail = null;
    notifyListeners();
  }
}
