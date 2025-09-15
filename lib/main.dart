// main.dart
import 'package:flutter/material.dart';
import 'package:healthai/features/notifications/utils/notification_utils.dart';
import 'package:healthai/features/pageView/splash_screen.dart';
import 'package:healthai/features/profile/complete_profile_screen.dart';
import 'package:healthai/features/profile/register/singUp_screen.dart';
import 'package:healthai/navigation/main_screen.dart';
import 'package:healthai/services/local_storage_service.dart';
import 'package:provider/provider.dart';

import 'features/Setting/settings_page.dart';
import 'features/notifications/provider/notification_provider.dart';
import 'features/profile/profile_screen.dart';
import 'features/profile/register/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تهيئة نظام الإشعارات
  await NotificationUtils.initialize();
  LocalStorageService.debugAllUsers();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthAI',

      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SingupScreen(),
        '/main': (context) => MainScreen(), // أهم سطر
        '/complete-profile': (context) =>
            CompleteProfileScreen(userName: '', email: ''),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsPage(),
      },
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );
  }
}
