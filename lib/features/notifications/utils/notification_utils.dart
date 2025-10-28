// utils/notification_utils.dart
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart'; // أضف هذا الاستيراد
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// أضف هذا الاستيراد
// أضف هذه الدالة في أعلى الملف، خارج أي class
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // التعامل مع النقر على الإشعار في الخلفية
  print('تم النقر على الإشعار في الخلفية: ${notificationResponse.payload}');
}

class NotificationUtils {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // تهيئة الوقت المنطقي
    tz.initializeTimeZones();

    // طلب صلاحيات الإشعارات
    await _requestPermissions();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    // تهيئة الإشعارات
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print('تم النقر على الإشعار: ${details.payload}');
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // // طلب الصلاحيات الإضافية لأندرويد 13+
    // if (plat.Platform.isAndroid) {
    //   final bool? result = await _notificationsPlugin
    //       .resolvePlatformSpecificImplementation<
    //         plat.AndroidFlutterLocalNotificationsPlugin
    //       >()
    //       ?.requestPermission();
    //   print('صلاحيات الإشعارات: $result');
    // }
  }

  static Future<void> _requestPermissions() async {
    // طلب صلاحية الإشعارات الأساسية
    var status = await Permission.notification.status;

    if (status.isDenied) {
      status = await Permission.notification.request();
    }

    print('حالة صلاحية الإشعارات: $status');

    // صلاحيات إضافية لأندرويد
    if (Platform.isAndroid) {
      try {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          // أندرويد 13+ - الصلاحية already requested فوق
          print('أندرويد 13+ - صلاحية الإشعارات: $status');
        } else {
          // الإصدارات الأقدم تحتاج صلاحية منفصلة
          final alarmStatus = await Permission.scheduleExactAlarm.status;
          if (alarmStatus.isDenied) {
            await Permission.scheduleExactAlarm.request();
          }
          print('حالة صلاحية المنبه الدقيق: $alarmStatus');
        }
      } catch (e) {
        print('خطأ في الحصول على معلومات الجهاز: $e');
        // كبديل آمن
        final alarmStatus = await Permission.scheduleExactAlarm.status;
        if (alarmStatus.isDenied) {
          await Permission.scheduleExactAlarm.request();
        }
      }
    }
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required bool isDaily,
    String? payload,
  }) async {
    // تحديد وقت الإشعار
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);
    // إعداد تفاصيل الإشعار للأندرويد ← هذا اللي بيظهر في الستارة!
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'التنبيهات',
          channelDescription: 'قناة التنبيهات اليومية',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      sound: 'default',
    );
    // دمج الإعدادات
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: isDaily
            ? DateTimeComponents.time
            : DateTimeComponents.dateAndTime,
      );
      print('تم جدولة الإشعار بنجاح: $body في $scheduledTime');
    } catch (e) {
      print('فشل في جدولة الإشعار: $e');
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
