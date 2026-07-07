import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../main.dart';
import 'pos_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const int pinLength = 6;
  String _pin = '';
  bool _isError = false;
  bool _isSuccess = false;

  void _onKeyPress(String digit) {
    if (_pin.length < pinLength && !_isSuccess) {
      setState(() {
        _isError = false;
        _pin += digit;
      });

      if (_pin.length == pinLength) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty && !_isSuccess) {
      setState(() {
        _isError = false;
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _onClear() {
    if (!_isSuccess) {
      setState(() {
        _isError = false;
        _pin = '';
      });
    }
  }

  void _verifyPin() {
    // Sebagai demo, PIN sukses adalah 555555
    if (_pin == '555555') {
      setState(() {
        _isSuccess = true;
        isStaffLoggedIn = true; // Set status login global agar persisten saat hot reload
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('PIN Benar! Masuk ke sistem kasir...'),
          backgroundColor: AppColors.primary500,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      // Navigasi ke Halaman Dashboard POS Utama setelah delay singkat
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PosDashboardScreen()),
          );
        }
      });
    } else {
      // Jika salah, indikator berkedip merah lalu terhapus otomatis
      setState(() {
        _isError = true;
      });
      Timer(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _pin = '';
            _isError = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Row(
        children: [
          // SISI KIRI: Antarmuka Input PIN Kasir
          Expanded(
            flex: 6,
            child: Container(
              color: AppColors.white,
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 380),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo Restoran: Haji Wong Halal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary500.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary500.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.storefront,
                                color: AppColors.primary500,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                'Haji Wong Halal',
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.h4Bold.copyWith(
                                  color: AppColors.neutral900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // Judul Masuk PIN
                        Text(
                          'Enter PIN',
                          textAlign: TextAlign.center,
                          style: AppTypography.h3Bold.copyWith(
                            color: AppColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your 6-digit staff passcode to log in',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMRegular.copyWith(
                            color: AppColors.neutral500,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Baris Indikator PIN (6 Lingkaran)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(pinLength, (index) {
                            final bool isFilled = index < _pin.length;
                            Color indicatorColor = AppColors.neutral200;
                            
                            if (_isError) {
                              indicatorColor = AppColors.error500;
                            } else if (_isSuccess) {
                              indicatorColor = AppColors.primary500;
                            } else if (isFilled) {
                              indicatorColor = AppColors.primary500;
                            }

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: indicatorColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: (isFilled || _isError || _isSuccess)
                                      ? Colors.transparent
                                      : AppColors.neutral300,
                                  width: 1,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 48),

                        // KEYPAD NUMERIK (1-9, Clear, 0, Backspace)
                        _buildKeypad(),
                        
                        const SizedBox(height: 24),
                        // Link Lupa PIN
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // Aksi lupa PIN kasir
                            },
                            child: Text(
                              'Forgot Staff PIN?',
                              style: AppTypography.bodySRegular.copyWith(
                                color: AppColors.primary500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // SISI KANAN: Panel Desain Wireframe Placeholder (Hanya tampil di Tablet)
          if (isTablet)
            Expanded(
              flex: 4,
              child: Container(
                color: const Color(0xFF141416),
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Elemen Wireframe Placeholder Kustom
                        Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            color: AppColors.neutral900,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.neutral800,
                              width: 2,
                            ),
                          ),
                          child: CustomPaint(
                            painter: WireframeBoxPainter(),
                            child: const Center(
                              child: Icon(
                                Icons.storefront_outlined,
                                color: Color(0xFF464646),
                                size: 64,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Teks Promosi / Motivasi di Bawah
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Stay In Control',
                                style: AppTypography.h4Bold.copyWith(
                                  color: AppColors.white,
                                  fontSize: 22,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Easily manage your store anytime, anywhere with a seamless login experience.',
                                textAlign: TextAlign.center,
                                style: AppTypography.bodySRegular.copyWith(
                                  color: AppColors.neutral400,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        _buildKeypadRow(['1', '2', '3']),
        const SizedBox(height: 16),
        _buildKeypadRow(['4', '5', '6']),
        const SizedBox(height: 16),
        _buildKeypadRow(['7', '8', '9']),
        const SizedBox(height: 16),
        _buildKeypadSpecialRow(),
      ],
    );
  }

  Widget _buildKeypadRow(List<String> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: values.map((val) => _buildKeypadButton(val)).toList(),
    );
  }

  Widget _buildKeypadSpecialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Tombol Clear (C)
        _buildSpecialButton(
          label: 'C',
          onPressed: _onClear,
        ),
        // Tombol Angka 0
        _buildKeypadButton('0'),
        // Tombol Backspace (Ikon Hapus)
        _buildSpecialButton(
          icon: Icons.backspace_outlined,
          onPressed: _onBackspace,
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String digit) {
    return SizedBox(
      width: 72,
      height: 72,
      child: OutlinedButton(
        onPressed: () => _onKeyPress(digit),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(color: AppColors.neutral200, width: 1.5),
          shape: const CircleBorder(),
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.neutral900,
        ),
        child: Text(
          digit,
          style: AppTypography.h4Bold.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialButton({String? label, IconData? icon, required VoidCallback onPressed}) {
    return SizedBox(
      width: 72,
      height: 72,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: BorderSide.none, // Tanpa border untuk tombol spesial agar minimalis
          shape: const CircleBorder(),
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.neutral700,
        ),
        child: label != null
            ? Text(
                label,
                style: AppTypography.bodyLBold.copyWith(
                  fontSize: 20,
                  color: AppColors.neutral700,
                ),
              )
            : Icon(
                icon,
                size: 20,
                color: AppColors.neutral700,
              ),
      ),
    );
  }
}

// Custom Painter untuk diagram wireframe
class WireframeBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF282828)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
