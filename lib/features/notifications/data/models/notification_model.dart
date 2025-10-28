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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'hour': time.hour,
      'minute': time.minute,
      'isDaily': isDaily,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      text: json['text'],
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      isDaily: json['isDaily'],
    );
  }

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
