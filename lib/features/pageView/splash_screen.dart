import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/responsive.dart';
import '../profile/register/login_screen.dart';

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showSplash = true;
  bool _isFirebaseInitialized = false;
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  _initializeApp() async {
    try {
      // انتظر حتى تكتمل تهيئة Firebase (تمت بالفعل في main)
      _isFirebaseInitialized = true;

      // التحقق من أول تشغيل للتطبيق
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

      if (isFirstLaunch) {
        // هذا أول تشغيل، عرض شاشة البداية
        await prefs.setBool('isFirstLaunch', false);
      } else {
        // ليس أول تشغيل، الانتقال مباشرة إلى شاشة التسجيل
        if (mounted) {
          setState(() {
            _showSplash = false;
          });
        }
      }
    } catch (e) {
      // في حالة حدوث خطأ في التهيئة
      if (mounted) {
        setState(() {
          _initializationError = e.toString();
          _showSplash = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initializationError != null) {
      return Scaffold(
        body: Center(
          child: Text('Error initializing app: $_initializationError'),
        ),
      );
    }

    return _showSplash ? const SplashScreen() : LoginScreen();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> splashData = [
    {
      "text": "Welcome to HEALTHILY, Let’s shop!",
      "animation": "assets/animations/Welcome_Animation.json",
    },
    {
      "text":
          "We help people connect with stores \naround United State of America",
      "animation": "assets/animations/health_blue.json",
    },
    {
      "text": "We show the easy way to shop. \nJust stay at home with us",
      "animation": "assets/animations/Doctor.json",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                flex: Responsive.isMobile(context) ? 4 : 3,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    animationPath: splashData[index]["animation"],
                    text: splashData[index]['text'],
                  ),
                ),
              ),
              Expanded(
                flex: Responsive.isMobile(context) ? 2 : 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.responsiveValue(
                      context,
                      mobile: 24,
                      tablet: 36,
                      desktop: 48,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      // مؤشرات التمرير المحسنة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: currentPage == index
                                ? Responsive.responsiveValue(
                                    context,
                                    mobile: 20,
                                    tablet: 24,
                                    desktop: 28,
                                  )
                                : Responsive.responsiveValue(
                                    context,
                                    mobile: 10,
                                    tablet: 12,
                                    desktop: 14,
                                  ),
                            height: Responsive.responsiveValue(
                              context,
                              mobile: 10,
                              tablet: 12,
                              desktop: 14,
                            ),
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? const Color(0xFF8EDDFF)
                                  : const Color(0xFFD8D8D8),
                              borderRadius: BorderRadius.circular(
                                Responsive.responsiveValue(
                                  context,
                                  mobile: 5,
                                  tablet: 6,
                                  desktop: 7,
                                ),
                              ),
                              boxShadow: [
                                if (currentPage == index)
                                  BoxShadow(
                                    color: const Color(
                                      0xFF8EDDFF,
                                    ).withOpacity(0.5),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                      // زر التخطي
                      if (currentPage < splashData.length - 1)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "تخطي",
                              style: TextStyle(
                                color: const Color(0xFF769DAD),
                                fontSize: Responsive.fontSize(
                                  context,
                                  mobile: 14,
                                  tablet: 16,
                                  desktop: 18,
                                ),
                                fontWeight: FontWeight.w600,
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
                      // زر الاستمرار
                      SizedBox(
                        width: double.infinity,
                        height: Responsive.responsiveValue(
                          context,
                          mobile: 48,
                          tablet: 56,
                          desktop: 60,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (currentPage < splashData.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              // الانتقال إلى الشاشة التالية
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8EDDFF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.responsiveValue(
                                  context,
                                  mobile: 12,
                                  tablet: 16,
                                  desktop: 20,
                                ),
                              ),
                            ),
                            elevation: 5,
                            shadowColor: const Color(
                              0xFF8EDDFF,
                            ).withOpacity(0.5),
                          ),
                          child: Text(
                            currentPage < splashData.length - 1
                                ? "التالي"
                                : "ابدا الان",
                            style: TextStyle(
                              fontSize: Responsive.fontSize(
                                context,
                                mobile: 16,
                                tablet: 18,
                                desktop: 20,
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
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

class SplashContent extends StatelessWidget {
  const SplashContent({super.key, this.text, this.animationPath});
  final String? text, animationPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(flex: 1),
        Text(
          "HEALTHILY",
          style: TextStyle(
            fontSize: Responsive.responsiveValue(
              context,
              mobile: 28,
              tablet: 32,
              desktop: 36,
            ),
            color: const Color(0xFF8EDDFF),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
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
        Text(
          text!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Responsive.fontSize(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
            color: const Color(0xFF6A6A6A),
            height: 1.5,
          ),
        ),
        const Spacer(flex: 1),
        // استخدام Lottie لعرض الرسوم المتحركة من ملف JSON في assets
        Container(
          width: Responsive.responsiveValue(
            context,
            mobile: 280,
            tablet: 320,
            desktop: 360,
          ),
          height: Responsive.responsiveValue(
            context,
            mobile: 300,
            tablet: 360,
            desktop: 400,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Responsive.responsiveValue(
                context,
                mobile: 16,
                tablet: 20,
                desktop: 24,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8EDDFF).withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Lottie.asset(animationPath!, fit: BoxFit.contain),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
