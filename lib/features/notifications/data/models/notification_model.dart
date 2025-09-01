// features/notifications/data/models/notification_model.dart
import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String text;
  final TimeOfDay time;
  final bool isDaily;

  NotificationModel({
    required this.id,
    required this.text,
    required this.time,
    required this.isDaily,
  });

  NotificationModel copyWith({
    String? id,
    String? text,
    TimeOfDay? time,
    bool? isDaily,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      text: text ?? this.text,
      time: time ?? this.time,
      isDaily: isDaily ?? this.isDaily,
    );
  }
}
