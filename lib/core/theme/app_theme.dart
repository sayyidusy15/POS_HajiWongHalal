import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppColors.white, // Default Light Mode Background (#FFFFFF)
      primaryColor: AppColors.primary500,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary500,
        secondary: AppColors.primary600,
        surface: AppColors.white,
        error: AppColors.error500,
      ),
      // Menerapkan Plus Jakarta Sans secara global ke textTheme Light
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.neutral900,
        displayColor: AppColors.neutral900,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.white,
        elevation: 2,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: AppColors.neutral200, // subtle border for light cards
            width: 1,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.neutral900),
        titleTextStyle: TextStyle(
          color: AppColors.neutral900,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.neutral200, // light gray divider (#E5E5E5)
        thickness: 1,
      ),
    );
  }

  // Tetap menyediakan darkTheme jika diperlukan di masa depan
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.neutral900,
      primaryColor: AppColors.primary500,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary500,
        secondary: AppColors.primary400,
        surface: AppColors.neutral800,
        error: AppColors.error500,
      ),
      textTheme: AppTypography.textTheme,
    );
  }
}
