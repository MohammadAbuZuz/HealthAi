import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../features/articles/articles_Screen.dart';
import '../features/home/chat/chat_screen.dart';
import '../features/medicalConsultation/medical_consultation_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/notifications/provider/notification_provider.dart';
import '../features/profile/profile_screen.dart';
import '../services/responsive.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screen = [
    ChatScreen(),
    MedicalConsultationScreen(),
    NotificationsScreen(),
    ArticlesScreen(),
    ProfileScreen(),
  ];
  int _currentIndex = 0;
  bool _notificationsLoaded =
      false; // علامة لتتبع إذا تم تحميل التنبيهات مسبقاً

  @override
  void initState() {
    super.initState();
    // تحميل التنبيهات مرة واحدة عند بداية التطبيق
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  // دالة منفصلة لتحميل التنبيهات
  Future<void> _loadNotifications() async {
    if (!_notificationsLoaded) {
      await Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).loadNotifications();
      setState(() {
        _notificationsLoaded = true;
      });
      print('تم تحميل التنبيهات للمستخدم الحالي');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // تحميل التنبيهات عند تغيير المستخدم
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = Responsive.responsiveValue(
      context,
      mobile: 24,
      tablet: 28,
      desktop: 32,
    );
    final fontSize = Responsive.fontSize(
      context,
      mobile: 10,
      tablet: 12,
      desktop: 14,
    );

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int? index) {
          setState(() {
            _currentIndex = index ?? 0;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF769DAD),
        unselectedItemColor: Colors.white,
        selectedItemColor: const Color(0xFF8EDDFF),
        selectedLabelStyle: TextStyle(fontSize: fontSize),
        unselectedLabelStyle: TextStyle(fontSize: fontSize),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/Home.svg',
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? const Color(0xFF8EDDFF) : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/medical_consultation.svg',
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? const Color(0xFF8EDDFF) : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'استشارة طبية',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/notification.svg',
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? const Color(0xFF8EDDFF) : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'التنبيهات',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/articles.svg',
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? const Color(0xFF8EDDFF) : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'مقالات',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/profile2.svg',
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                _currentIndex == 4 ? const Color(0xFF8EDDFF) : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: 'ملف الشخصي',
          ),
        ],
      ),
      body: _screen[_currentIndex],
    );
  }
}
