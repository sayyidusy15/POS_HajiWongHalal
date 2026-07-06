import 'package:flutter/material.dart';

class AppColors {
  // --- PRIMARY COLORS (Emerald Green - Figma Specs) ---
  static const Color primary50 = Color(0xFFF3FAF7);
  static const Color primary100 = Color(0xFFDAF4E6);
  static const Color primary200 = Color(0xFFBEEDD2);
  static const Color primary300 = Color(0xFF98E4B8);
  static const Color primary400 = Color(0xFF6AD896);
  static const Color primary500 = Color(0xFF34CB62); // Brand Base
  static const Color primary600 = Color(0xFF2EB362);
  static const Color primary700 = Color(0xFF289656);
  static const Color primary800 = Color(0xFF218347);
  static const Color primary900 = Color(0xFF1A6637);

  // --- NEUTRAL COLORS (Charcoal/Grey Scale - Figma Specs) ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color neutral300 = Color(0xFFD8D7D7);
  static const Color neutral400 = Color(0xFF8F8F8F);
  static const Color neutral500 = Color(0xFF757575);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF464646);
  static const Color neutral800 = Color(0xFF282828);
  static const Color neutral900 = Color(0xFF141414); // Scaffold BG

  // --- ERROR COLORS (Red-Oranye - Figma Specs) ---
  static const Color error100 = Color(0xFFFDE8E8);
  static const Color error200 = Color(0xFFFBD5D5);
  static const Color error300 = Color(0xFFF8B4B4);
  static const Color error400 = Color(0xFFF98080);
  static const Color error500 = Color(0xFFF04D28);

  // --- WARNING COLORS (Gold-Amber - Figma Specs) ---
  static const Color warning100 = Color(0xFFFEF3C7);
  static const Color warning200 = Color(0xFFFDE68A);
  static const Color warning300 = Color(0xFFFCD34D);
  static const Color warning400 = Color(0xFFFBBF24);
  static const Color warning500 = Color(0xFFFFAB00);

  // --- INFO COLORS (Blue - Figma Specs) ---
  static const Color info100 = Color(0xFFEBF8FF);
  static const Color info200 = Color(0xFFBEE3F8);
  static const Color info300 = Color(0xFF90CDF4);
  static const Color info400 = Color(0xFF63B3ED);
  static const Color info500 = Color(0xFF1D90FB);

  // --- GRADIENTS ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF35C56E), Color(0xFF2E9055)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neutralGradient = LinearGradient(
    colors: [neutral700, neutral900],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient infoGradient = LinearGradient(
    colors: [Color(0xFF1D90FB), Color(0xFF0E5EA9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFAB00), Color(0xFFC4880C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFF04D28), Color(0xFFAA3714)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
