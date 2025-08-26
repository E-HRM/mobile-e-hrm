import 'package:e_hrm/screens/auth/login/login_screen.dart';
import 'package:e_hrm/screens/opening/opening_screen.dart';
import 'package:e_hrm/utils/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-HRM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const OpeningScreen(),
      routes: {'/login': (context) => const LoginScreen()},
    );
  }
}
