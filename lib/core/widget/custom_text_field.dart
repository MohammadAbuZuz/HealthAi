import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
    required this.iconPath,
    this.validator,
  });

  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final String iconPath;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFFFF0000), width: 0.5),
          ),
          filled: true,
          fillColor: const Color(0xFFF2F2F2),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(
              14,
            ), // تباعد متساوي يحافظ على المحاذاة
            child: SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}
