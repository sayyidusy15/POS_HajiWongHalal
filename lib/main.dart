import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  runApp(const DynastyPOSApp());
}

class DynastyPOSApp extends StatelessWidget {
  const DynastyPOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restoran Dynasty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Default to Light Mode theme
      home: const LoginScreen(),
    );
  }
}
