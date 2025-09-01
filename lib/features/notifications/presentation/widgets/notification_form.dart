// features/notifications/presentation/widgets/notification_form.dart
import 'package:flutter/material.dart';
import 'package:healthai/core/widget/custom_button.dart';
import 'package:healthai/features/notifications/presentation/widgets/time_picker_button.dart';

import '../../data/models/notification_model.dart';
import 'notification_text_field.dart';

class NotificationForm extends StatefulWidget {
  final Function(NotificationModel) onSave;

  const NotificationForm({super.key, required this.onSave});

  @override
  State<NotificationForm> createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  final TextEditingController _textController = TextEditingController();
  TimeOfDay? _selectedTime;
  bool _isDaily = true;

  void _saveNotification() {
    if (_textController.text.isEmpty || _selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى ملء جميع الحقول')));
      return;
    }

    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _textController.text,
      time: _selectedTime!,
      isDaily: _isDaily,
    );

    widget.onSave(notification);

    // إعادة تعيين النموذج
    _textController.clear();
    setState(() {
      _selectedTime = null;
      _isDaily = true;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم حفظ التنبيه بنجاح')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15),
        NotificationTextField(
          label: 'نص التنبيه',
          hintText: 'ادخل نص التنبيه هنا',
          controller: _textController,
        ),
        const SizedBox(height: 20),
        TimePickerButton(
          initialTime: _selectedTime,
          onTimeSelected: (time) {
            setState(() {
              _selectedTime = time;
            });
          },
          label: 'وقت التنبيه',
        ),
        const SizedBox(height: 20),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('التكرار', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('يومي'),
                        leading: Radio<bool>(
                          value: true,
                          groupValue: _isDaily,
                          onChanged: (value) {
                            setState(() {
                              _isDaily = value!;
                            });
                          },
                          activeColor: const Color(0xFF769DAD),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('مرة واحدة'),
                        leading: Radio<bool>(
                          value: false,
                          groupValue: _isDaily,
                          onChanged: (value) {
                            setState(() {
                              _isDaily = value!;
                            });
                          },
                          activeColor: const Color(0xFF769DAD),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        CustomButton(text: 'حفظ التنبيه', onPressed: _saveNotification),
      ],
    );
  }
}
