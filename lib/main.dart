import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/pos_dashboard_screen.dart';

// Variabel status login staf untuk mencegah kembali ke login screen saat hot reload
bool isStaffLoggedIn = false;

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
      theme: AppTheme.lightTheme,
      // Mengarahkan langsung ke POS Dashboard jika sudah login saat hot reload
      home: isStaffLoggedIn ? const PosDashboardScreen() : const LoginScreen(),
    );
  }
}
