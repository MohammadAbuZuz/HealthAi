import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/widget/custom_button.dart';
import '../../core/widget/custom_text_field.dart';
import '../../services/local_storage_service.dart';
import '../profile/complete_profile_screen.dart';

class SingupScreen extends StatefulWidget {
  @override
  State<SingupScreen> createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  final TextEditingController firstUsernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool _isLoading = false;
  // إضافة مؤشر تحميل
  Future<void> _createAccount(BuildContext context) async {
    if (_key.currentState?.validate() ?? false) {
      // التحقق من تطابق كلمتي المرور
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("كلمات المرور غير متطابقة")),
        );
        return;
      }

      setState(() => _isLoading = true); // بدء التحميل

      try {
        // إنشاء حساب في التخزين المحلي
        final userData = {
          'username': firstUsernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'createdAt': DateTime.now().toString(),
        };

        final success = await LocalStorageService.registerUser(userData);

        if (success) {
          // إذا نجح إنشاء الحساب، الانتقال إلى شاشة إكمال الملف الشخصي
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CompleteProfileScreen(
                userName: firstUsernameController.text,
                email: emailController.text,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("هذا البريد الإلكتروني مستخدم بالفعل"),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("حدث خطأ أثناء إنشاء الحساب: $e")),
        );
      } finally {
        setState(() => _isLoading = false); // إيقاف التحميل
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(height: 100),
                  Positioned(
                    left: 100,
                    child: SvgPicture.asset(
                      'assets/images/Rectangle2.svg',
                      width: 200,
                      height: 100,
                    ),
                  ),
                  Positioned(
                    child: SvgPicture.asset(
                      'assets/images/Rectangle1.svg',
                      width: 200,
                      height: 100,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'Let’s Get Started!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Create an account on MNZL to get all features',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 32),
                      CustomTextField(
                        controller: firstUsernameController,
                        obscureText: false,
                        hintText: 'UserName',
                        iconPath: 'assets/images/user.svg',
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Your UserName ";
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: emailController, // تغيير الاسم ليكون أوضح
                        obscureText: false,
                        hintText: 'Email',
                        iconPath: 'assets/images/email.svg',
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Your Email ";
                          }
                          // تحقق من صيغة البريد الإلكتروني
                          if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(value)) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: passwordController,
                        obscureText: true,
                        hintText: 'Password',
                        iconPath: 'assets/images/lock.svg',
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Your Password ";
                          }
                          // تحقق من قوة كلمة المرور (6 أحرف على الأقل)
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        hintText: 'Confirm Password',
                        iconPath: 'assets/images/lock.svg',
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Your Confirm Password ";
                          }
                          if (value != passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      CustomButton(
                        text: 'CREATE',
                        onPressed: () =>
                            _createAccount(context), // استدعاء دالة الإنشاء
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                              ); // العودة لشاشة تسجيل الدخول
                            },
                            child: Text(
                              'Login here',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
