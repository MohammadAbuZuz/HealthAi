import 'package:flutter/material.dart';

import '../../../../services/responsive.dart'; // تأكد من مسار كلاس Responsive

class TimePickerButton extends StatefulWidget {
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final String label;

  const TimePickerButton({
    super.key,
    this.initialTime,
    required this.onTimeSelected,
    required this.label,
  });

  @override
  State<TimePickerButton> createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<TimePickerButton> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF769DAD)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.responsiveValue(
      context,
      mobile: 12,
      tablet: 16,
      desktop: 20,
    );
    final verticalPadding = Responsive.responsiveValue(
      context,
      mobile: 12,
      tablet: 16,
      desktop: 20,
    );
    final borderRadius = Responsive.responsiveValue(
      context,
      mobile: 6,
      tablet: 8,
      desktop: 12,
    );
    final iconSize = Responsive.responsiveValue(
      context,
      mobile: 20,
      tablet: 24,
      desktop: 28,
    );
    final fontSize = Responsive.fontSize(
      context,
      mobile: 14,
      tablet: 16,
      desktop: 18,
    );
    final labelFontSize = Responsive.fontSize(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );

    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding / 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: verticalPadding / 2),
            InkWell(
              onTap: () => _selectTime(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : 'اختر الوقت 😊',
                      style: TextStyle(
                        color: _selectedTime != null
                            ? Colors.black
                            : Colors.grey,
                        fontSize: fontSize,
                      ),
                    ),
                    Icon(
                      Icons.access_time,
                      color: const Color(0xFF769DAD),
                      size: iconSize,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
