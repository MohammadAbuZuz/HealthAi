import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthai/core/widget/custom_button.dart';
import 'package:healthai/core/widget/custom_text_field.dart';
import 'package:healthai/features/profile/register/singUp_screen.dart';
import 'package:healthai/navigation/main_screen.dart';

import '../../../services/local_storage_service.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool _isLoading = false;

  // إضافة مؤشر تحميل
  Future<void> _signIn(BuildContext context) async {
    if (_key.currentState?.validate() ?? false) {
      setState(() => _isLoading = true); // بدء التحميل

      try {
        // تسجيل الدخول باستخدام التخزين المحلي
        final user = await LocalStorageService.login(
          emailController.text,
          passwordController.text,
        );

        if (user != null) {
          // إذا نجح تسجيل الدخول، الانتقال إلى الشاشة الرئيسية
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("البريد الإلكتروني أو كلمة المرور غير صحيحة"),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("حدث خطأ أثناء تسجيل الدخول: $e")),
        );
      } finally {
        setState(() => _isLoading = false); // إيقاف التحميل
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Form(
          key: _key,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'HealthAi',
                            style: TextStyle(
                              fontSize: 50,
                              foreground: Paint()
                                ..shader =
                                    LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF8EDDFF),
                                        Color(0xFF769DAD),
                                      ],
                                    ).createShader(
                                      Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                    ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'مرحبًا بعودتك!',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 18),
                          Text(
                            'تسجيل إلى الحسابك الحالي',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                    CustomTextField(
                      controller:
                          emailController, // استخدام متحكم البريد الإلكتروني
                      obscureText: false,
                      hintText: 'بريد إلكتروني', // تغيير من Username إلى Email
                      iconPath: 'assets/images/email.svg', // تغيير الأيقونة
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "الرجاء إدخال بريدك الإلكتروني";
                        }
                        // تحقق من صيغة البريد الإلكتروني
                        if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
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
                          return 'الرجاء إدخال كلمة المرور الكاملة';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        //الانتقال لشاشة استعادة كلمة المرور
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                        );
                      },
                      child: Text(
                        'هل نسيت كلمة السر؟',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    CustomButton(
                      text: 'تسجيل الدخول',
                      onPressed: () =>
                          _signIn(context), // استدعاء دالة تسجيل الدخول
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        'أو قم بالتسجيل باستخدام الخدمة غير متاحة حاليا',
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 50, right: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //not done
                        children: [
                          SvgPicture.asset('assets/images/fracbook.svg'),
                          SvgPicture.asset('assets/images/google.svg'),
                          SvgPicture.asset('assets/images/iphon.svg'),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('لا يوجد لديك حساب؟'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingupScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'اشتراك',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
