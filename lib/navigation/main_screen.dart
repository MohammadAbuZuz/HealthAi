import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthai/features/articles/articles_Screen.dart';
import 'package:healthai/features/home/home_screen.dart';
import 'package:healthai/features/medicalConsultation/medical_consultation_screen.dart';
import 'package:healthai/features/notifications/notifications_screen.dart';

import '../features/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screen = [
    HomeScreen(),
    MedicalConsultationScreen(),
    NotificationsScreen(),
    ArticlesScreen(),
    ProfileScreen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int? index) {
          setState(() {
            _currentIndex = index ?? 0;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF769DAD),
        unselectedItemColor: Color(0xFFFFFFFF),
        selectedItemColor: Color(0xFF8EDDFF),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/Home.svg',
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? Color(0xFF8EDDFF) : Color(0xFFFFFFFF),
                BlendMode.srcIn,
              ),
            ),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/medical_consultation.svg',
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? Color(0xFF8EDDFF) : Color(0xFFFFFFFF),
                BlendMode.srcIn,
              ),
            ),
            label: 'استشارة طبية',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/notification.svg',
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? Color(0xFF8EDDFF) : Color(0xFFFFFFFF),
                BlendMode.srcIn,
              ),
            ),
            label: 'التنبيهات',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/articles.svg',
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? Color(0xFF8EDDFF) : Color(0xFFFFFFFF),
                BlendMode.srcIn,
              ),
            ),
            label: 'مقالات',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/profile2.svg',
              colorFilter: ColorFilter.mode(
                _currentIndex == 4 ? Color(0xFF8EDDFF) : Color(0xFFFFFFFF),
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
