import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthai/core/widget/custom_button.dart';
import 'package:healthai/core/widget/custom_text_field.dart';
import 'package:healthai/features/profile/register/singUp_screen.dart';
import 'package:healthai/navigation/main_screen.dart';

import '../../../services/local_storage_service.dart';
import '../../../services/responsive.dart';
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

  Future<void> _signIn(BuildContext context) async {
    if (_key.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final user = await LocalStorageService.login(
          emailController.text,
          passwordController.text,
        );

        if (user != null && user['password'] != null) {
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
        setState(() => _isLoading = false);
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
              // Header Section with responsive height
              SizedBox(
                height: Responsive.responsiveValue(
                  context,
                  mobile: Responsive.screenHeight(context) * 0.12,
                  tablet: Responsive.screenHeight(context) * 0.15,
                  desktop: Responsive.screenHeight(context) * 0.18,
                ),
                child: Stack(
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
              ),

              // Form Content with responsive padding
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.responsiveValue(
                    context,
                    mobile: 20,
                    tablet: 36,
                    desktop: 48,
                  ),
                  vertical: Responsive.responsiveValue(
                    context,
                    mobile: 16,
                    tablet: 24,
                    desktop: 32,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'HealthAi',
                            style: TextStyle(
                              fontSize: Responsive.responsiveValue(
                                context,
                                mobile: 32,
                                tablet: 40,
                                desktop: 48,
                              ),
                              foreground: Paint()
                                ..shader =
                                    LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF8EDDFF),
                                        Color(0xFF769DAD),
                                      ],
                                    ).createShader(
                                      Rect.fromLTWH(
                                        0.0,
                                        0.0,
                                        Responsive.responsiveValue(
                                          context,
                                          mobile: 160,
                                          tablet: 200,
                                          desktop: 240,
                                        ),
                                        Responsive.responsiveValue(
                                          context,
                                          mobile: 50,
                                          tablet: 70,
                                          desktop: 90,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: Responsive.responsiveValue(
                              context,
                              mobile: 4,
                              tablet: 8,
                              desktop: 12,
                            ),
                          ),
                          Text(
                            'مرحبًا بعودتك!',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: Responsive.fontSize(
                                    context,
                                    mobile: 18,
                                    tablet: 20,
                                    desktop: 22,
                                  ),
                                ),
                          ),
                          SizedBox(
                            height: Responsive.responsiveValue(
                              context,
                              mobile: 4,
                              tablet: 8,
                              desktop: 12,
                            ),
                          ),
                          Text(
                            'تسجيل إلى الحسابك الحالي',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontSize: Responsive.fontSize(
                                    context,
                                    mobile: 14,
                                    tablet: 16,
                                    desktop: 18,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: Responsive.responsiveValue(
                        context,
                        mobile: 16,
                        tablet: 24,
                        desktop: 32,
                      ),
                    ),

                    // Email Field
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
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                        ).hasMatch(value)) {
                          return "الرجاء إدخال بريد إلكتروني صالح";
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: Responsive.responsiveValue(
                        context,
                        mobile: 12,
                        tablet: 16,
                        desktop: 20,
                      ),
                    ),

                    // Password Field
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

                    SizedBox(
                      height: Responsive.responsiveValue(
                        context,
                        mobile: 8,
                        tablet: 12,
                        desktop: 16,
                      ),
                    ),

                    // Forgot Password
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                        );
                      },
                      child: Text(
                        'هل نسيت كلمة السر؟',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontSize: Responsive.fontSize(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                            ),
                      ),
                    ),

                    SizedBox(
                      height: Responsive.responsiveValue(
                        context,
                        mobile: 16,
                        tablet: 24,
                        desktop: 32,
                      ),
                    ),

                    // Login Button
                    CustomButton(
                      text: 'تسجيل الدخول',
                      onPressed: () => _signIn(context),
                    ),

                    SizedBox(
                      height: Responsive.responsiveValue(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),

                    // Divider Text
                    Center(
                      child: Text(
                        'أو قم بالتسجيل باستخدام الخدمة غير متاحة حاليا',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 16,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: Responsive.responsiveValue(
                        context,
                        mobile: 12,
                        tablet: 16,
                        desktop: 20,
                      ),
                    ),

                    // Social Login Icons
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.responsiveValue(
                          context,
                          mobile: 20,
                          tablet: 50,
                          desktop: 80,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            'assets/images/fracbook.svg',
                            width: Responsive.responsiveValue(
                              context,
                              mobile: 32,
                              tablet: 40,
                              desktop: 48,
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/images/google.svg',
                            width: Responsive.responsiveValue(
                              context,
                              mobile: 32,
                              tablet: 40,
                              desktop: 48,
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/images/iphon.svg',
                            width: Responsive.responsiveValue(
                              context,
                              mobile: 32,
                              tablet: 40,
                              desktop: 48,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: Responsive.responsiveValue(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لا يوجد لديك حساب؟',
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
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: Responsive.fontSize(
                                    context,
                                    mobile: 12,
                                    tablet: 14,
                                    desktop: 16,
                                  ),
                                ),
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
