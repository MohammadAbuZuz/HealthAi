import 'package:flutter/material.dart';
import 'package:healthai/core/widget/custom_button.dart';
import 'package:healthai/core/widget/custom_text_field.dart';
import 'package:healthai/navigation/main_screen.dart';

import '../../../services/local_storage_service.dart';
import '../../../services/responsive.dart'; // استدعاء كلاس Responsive

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool _isLoading = false;

  Future<void> _updatePassword(BuildContext context) async {
    if (_key.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final currentUser = await LocalStorageService.getCurrentUser();
        if (currentUser != null) {
          final updatedUser = {...currentUser};
          updatedUser['password'] = newPasswordController.text;

          await LocalStorageService.updateUser(updatedUser);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم تحديث كلمة المرور بنجاح")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("يجب تسجيل الدخول أولاً")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("حدث خطأ: $e")));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تغيير كلمة المرور')),
      body: Container(
        padding: Responsive.responsivePadding(
          context,
          mobile: const EdgeInsets.all(20),
          tablet: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          desktop: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Responsive.responsiveValue(
                    context,
                    mobile: 20,
                    tablet: 40,
                    desktop: 60,
                  ),
                ),
                Text(
                  'كلمة المرور الجديدة',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(
                      context,
                      mobile: 20,
                      tablet: 24,
                      desktop: 28,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: Responsive.responsiveValue(
                    context,
                    mobile: 10,
                    tablet: 20,
                    desktop: 30,
                  ),
                ),
                Text(
                  'أدخل كلمة المرور الجديدة',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(
                      context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 18,
                    ),
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: Responsive.responsiveValue(
                    context,
                    mobile: 20,
                    tablet: 30,
                    desktop: 40,
                  ),
                ),
                CustomTextField(
                  controller: newPasswordController,
                  obscureText: true,
                  hintText: 'كلمة المرور الجديدة',
                  iconPath: 'assets/images/lock.svg',
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "الرجاء إدخال كلمة المرور الجديدة";
                    }
                    if (value.length < 6) {
                      return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: Responsive.responsiveValue(
                    context,
                    mobile: 15,
                    tablet: 25,
                    desktop: 35,
                  ),
                ),
                CustomTextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  hintText: 'تأكيد كلمة المرور الجديدة',
                  iconPath: 'assets/images/lock.svg',
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "الرجاء تأكيد كلمة المرور";
                    }
                    if (value != newPasswordController.text) {
                      return "كلمات المرور غير متطابقة";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: Responsive.responsiveValue(
                    context,
                    mobile: 25,
                    tablet: 35,
                    desktop: 50,
                  ),
                ),
                CustomButton(
                  text: 'تغيير كلمة المرور',
                  onPressed: () => _updatePassword(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
