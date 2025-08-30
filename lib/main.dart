// main.dart
import 'package:flutter/material.dart';
import 'package:healthai/features/pageView/splash_screen.dart';
import 'package:healthai/features/profile/complete_profile_screen.dart';
import 'package:healthai/features/profile/register/singUp_screen.dart';
import 'package:healthai/navigation/main_screen.dart';

import 'features/profile/register/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
      },
    );
  }
}
