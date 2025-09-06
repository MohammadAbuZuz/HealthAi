import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthai/core/widget/custom_button.dart';
import 'package:healthai/core/widget/custom_text_field.dart';
import 'package:healthai/services/local_storage_service.dart';

import '../../../services/responsive.dart';
import '../complete_profile_screen.dart';

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

  Future<void> _createAccount(BuildContext context) async {
    if (_key.currentState?.validate() ?? false) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("كلمات المرور غير متطابقة")),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final userData = {
          'username': firstUsernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'createdAt': DateTime.now().toString(),
        };

        final success = await LocalStorageService.registerUser(userData);

        if (success) {
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
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // الجزء العلوي مع الـ SVG
            Stack(
              children: [
                Container(height: 50),
                Positioned(
                  child: SvgPicture.asset(
                    'assets/images/Rectangle1.svg',
                    width: Responsive.responsiveValue(
                      context,
                      mobile: Responsive.screenWidth(context) * 0.4,
                      tablet: Responsive.screenWidth(context) * 0.5,
                      desktop: Responsive.screenWidth(context) * 0.6,
                    ),
                    height: Responsive.responsiveValue(
                      context,
                      mobile: Responsive.screenHeight(context) * 0.12,
                      tablet: Responsive.screenHeight(context) * 0.15,
                      desktop: Responsive.screenHeight(context) * 0.18,
                    ),
                  ),
                ),
                Positioned(
                  right: Responsive.responsiveValue(
                    context,
                    mobile: Responsive.screenWidth(context) * 0.2,
                    tablet: Responsive.screenWidth(context) * 0.25,
                    desktop: Responsive.screenWidth(context) * 0.3,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/Rectangle2.svg',
                    width: Responsive.responsiveValue(
                      context,
                      mobile: Responsive.screenWidth(context) * 0.4,
                      tablet: Responsive.screenWidth(context) * 0.5,
                      desktop: Responsive.screenWidth(context) * 0.6,
                    ),
                    height: Responsive.responsiveValue(
                      context,
                      mobile: Responsive.screenHeight(context) * 0.12,
                      tablet: Responsive.screenHeight(context) * 0.15,
                      desktop: Responsive.screenHeight(context) * 0.18,
                    ),
                  ),
                ),
              ],
            ),
            // الفورم
            Padding(
              padding: Responsive.responsivePadding(
                context,
                mobile: const EdgeInsets.all(20),
                tablet: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 30,
                ),
                desktop: const EdgeInsets.symmetric(
                  horizontal: 120,
                  vertical: 50,
                ),
              ),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    SizedBox(
                      height: Responsive.responsiveValue(
                        context,
                        mobile: 30,
                        tablet: 50,
                        desktop: 70,
                      ),
                    ),
                    Text(
                      'دعونا نبدأ!',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(
                          context,
                          mobile: 20,
                          tablet: 26,
                          desktop: 32,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'قم بإنشاء حساب على MNZL للحصول على كافة الميزات',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Responsive.fontSize(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                        color: Colors.grey[700],
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

                    // حقول الإدخال
                    CustomTextField(
                      controller: firstUsernameController,
                      obscureText: false,
                      hintText: 'اسم المستخدم',
                      iconPath: 'assets/images/user.svg',
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "الرجاء إدخال اسم المستخدم الخاص بك";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: emailController,
                      obscureText: false,
                      hintText: 'بريد إلكتروني',
                      iconPath: 'assets/images/email.svg',
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "الرجاء إدخال بريدك الإلكتروني";
                        }
                        if (!RegExp(
                          r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$",
                        ).hasMatch(value)) {
                          return "الرجاء إدخال بريد إلكتروني صالح";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: passwordController,
                      obscureText: true,
                      hintText: 'كلمة المرور',
                      iconPath: 'assets/images/lock.svg',
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "الرجاء إدخال كلمة المرور الخاصة بك";
                        }
                        if (value.length < 6) {
                          return "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل";
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      hintText: 'تأكيد كلمة المرور',
                      iconPath: 'assets/images/lock.svg',
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "الرجاء إدخال كلمة المرور للتأكيد";
                        }
                        if (value != passwordController.text) {
                          return "كلمات المرور غير متطابقة";
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
                    CustomButton(
                      text: 'إنشاء',
                      onPressed: () => _createAccount(context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'هل لديك حساب بالفعل؟',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(
                              context,
                              mobile: 12,
                              tablet: 14,
                              desktop: 16,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'تسجيل الدخول هنا',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
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
    );
  }
}
