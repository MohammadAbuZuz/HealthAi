import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../services/responsive.dart';

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
      padding: Responsive.responsivePadding(
        context,
        mobile: const EdgeInsets.symmetric(vertical: 8),
        tablet: const EdgeInsets.symmetric(vertical: 12),
        desktop: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: TextStyle(
          fontSize: Responsive.fontSize(
            context,
            mobile: 14,
            tablet: 16,
            desktop: 18,
          ),
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              Responsive.responsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
            ),
            borderSide: const BorderSide(color: Color(0xFFFF0000), width: 0.5),
          ),
          filled: true,
          fillColor: const Color(0xFFF2F2F2),
          prefixIcon: Padding(
            padding: EdgeInsets.all(
              Responsive.responsiveValue(
                context,
                mobile: 10,
                tablet: 12,
                desktop: 14,
              ),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: Responsive.responsiveValue(
                context,
                mobile: 16,
                tablet: 22,
                desktop: 26,
              ),
              height: Responsive.responsiveValue(
                context,
                mobile: 16,
                tablet: 22,
                desktop: 26,
              ),
              fit: BoxFit.contain,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: Responsive.fontSize(
              context,
              mobile: 13,
              tablet: 15,
              desktop: 17,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: Responsive.responsiveValue(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
            horizontal: Responsive.responsiveValue(
              context,
              mobile: 10,
              tablet: 12,
              desktop: 14,
            ),
          ),
        ),
      ),
    );
  }
}
