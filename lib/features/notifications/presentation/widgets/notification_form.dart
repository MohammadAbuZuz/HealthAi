// features/notifications/presentation/widgets/notification_form.dart
import 'package:flutter/material.dart';
import 'package:healthai/core/widget/custom_button.dart';
import 'package:healthai/features/notifications/presentation/widgets/time_picker_button.dart';
import 'package:healthai/services/responsive.dart'; // تأكد من استيراد Responsive

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
        SizedBox(
          height: Responsive.responsiveValue(
            context,
            mobile: 12,
            tablet: 15,
            desktop: 18,
          ),
        ),
        NotificationTextField(
          label: 'نص التنبيه',
          hintText: 'ادخل نص التنبيه هنا',
          controller: _textController,
        ),
        SizedBox(
          height: Responsive.responsiveValue(
            context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        ),
        TimePickerButton(
          initialTime: _selectedTime,
          onTimeSelected: (time) {
            setState(() {
              _selectedTime = time;
            });
          },
          label: 'وقت التنبيه',
        ),
        SizedBox(
          height: Responsive.responsiveValue(
            context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        ),
        Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.responsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
              vertical: Responsive.responsiveValue(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التكرار',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: Responsive.fontSize(
                      context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: Responsive.responsiveValue(
                    context,
                    mobile: 6,
                    tablet: 8,
                    desktop: 10,
                  ),
                ),
                // تخطيط متجاوب لخيارات التكرار
                Responsive.isMobile(context)
                    ? Column(
                        children: [
                          _buildRadioOption(true, 'يومي'),
                          SizedBox(height: 8),
                          _buildRadioOption(false, 'مرة واحدة'),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: _buildRadioOption(true, 'يومي')),
                          SizedBox(
                            width: Responsive.responsiveValue(
                              context,
                              mobile: 8,
                              tablet: 12,
                              desktop: 16,
                            ),
                          ),
                          Expanded(
                            child: _buildRadioOption(false, 'مرة واحدة'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: Responsive.responsiveValue(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 28,
          ),
        ),
        CustomButton(text: 'حفظ التنبيه', onPressed: _saveNotification),
      ],
    );
  }

  // دالة مساعدة لبناء خيارات الراديو
  Widget _buildRadioOption(bool value, String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: Responsive.fontSize(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
      ),
      leading: Radio<bool>(
        value: value,
        groupValue: _isDaily,
        onChanged: (newValue) {
          setState(() {
            _isDaily = newValue!;
          });
        },
        activeColor: const Color(0xFF769DAD),
      ),
      contentPadding: EdgeInsets.only(
        left: Responsive.responsiveValue(
          context,
          mobile: 0,
          tablet: 4,
          desktop: 8,
        ),
      ),
      minLeadingWidth: Responsive.responsiveValue(
        context,
        mobile: 32,
        tablet: 40,
        desktop: 48,
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
