import 'package:flutter/material.dart';
import 'package:healthai/core/widget/custom_button.dart';
import 'package:healthai/core/widget/custom_text_field.dart';
import 'package:healthai/navigation/main_screen.dart';

import '../../../services/local_storage_service.dart';

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
        padding: const EdgeInsets.all(36),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'كلمة المرور الجديدة',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'أدخل كلمة المرور الجديدة',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 30),
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
