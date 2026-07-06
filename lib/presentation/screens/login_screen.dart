import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Logic login offline placeholder
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login berhasil! Masuk ke sistem kasir...'),
          backgroundColor: AppColors.primary500,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Light Mode White Background (#FFFFFF)
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo Restoran Dynasty
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
                      Text(
                        'Restoran Dynasty',
                        style: AppTypography.h4Bold.copyWith(
                          color: AppColors.neutral900, // Black text in Light Mode
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Judul Login & Subjudul
                  Text(
                    'Login',
                    style: AppTypography.h2Bold.copyWith(
                      color: AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Access your account to continue',
                    style: AppTypography.bodyMRegular.copyWith(
                      color: AppColors.neutral500, // Gray text in Light Mode
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Input Email / Phone Number
                  Text(
                    'Email or Phone Number',
                    style: AppTypography.bodySMedium.copyWith(
                      color: AppColors.neutral800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTypography.bodyMRegular.copyWith(color: AppColors.neutral900),
                    decoration: _buildInputDecoration('Enter your phone number or email'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email or phone number is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Input Password
                  Text(
                    'Password',
                    style: AppTypography.bodySMedium.copyWith(
                      color: AppColors.neutral800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: AppTypography.bodyMRegular.copyWith(color: AppColors.neutral900),
                    decoration: _buildInputDecoration('Enter your password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.neutral400,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Remember Me & Forgot Password Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: AppColors.primary500,
                              checkColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(
                                color: AppColors.neutral300,
                                width: 1.5,
                              ),
                              onChanged: (bool? value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Remember me',
                            style: AppTypography.bodySRegular.copyWith(
                              color: AppColors.neutral700,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Lupa password
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Forgot password?',
                          style: AppTypography.bodySRegular.copyWith(
                            color: AppColors.primary500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // Tombol Login (Menggunakan Widget Kustom AppButton variant Gradient)
                  AppButton(
                    text: 'Login',
                    variant: AppButtonVariant.gradient,
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 24),

                  // Teks Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodySRegular.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigasi Sign Up
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTypography.bodySRegular.copyWith(
                            color: AppColors.primary500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.neutral100, // Light Gray Input Field Background (#F5F5F5)
      hintText: hintText,
      hintStyle: AppTypography.bodyMRegular.copyWith(
        color: AppColors.neutral400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.neutral200, // gray border default (#E5E5E5)
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.neutral200,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary500, // Green focus border
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error500,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error500,
          width: 1.5,
        ),
      ),
      errorStyle: AppTypography.bodyXsRegular.copyWith(
        color: AppColors.error500,
      ),
    );
  }
}
