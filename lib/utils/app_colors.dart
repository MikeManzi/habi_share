import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryPurple = Color(0xFF8B4A8C);
  static const Color primaryPink = Color(0xFFB85A8F);
  static const Color primaryMagenta = Color(0xFFD16B92);

  // Gradient Colors
  static const Color gradientStart = Color(0xFF8B4A8C);
  static const Color gradientMiddle = Color(0xFFB85A8F);
  static const Color gradientEnd = Color(0xFFD16B92);

  // Background Colors
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color backgroundOverlay = Color(0x80000000); // 50% black overlay
  static const Color backgroundCard = Color(0x1AFFFFFF); // 10% white overlay

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textHint = Color(0xFF666666);
  static const Color textDisabled = Color(0xFF404040);

  // Input Field Colors
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFocusedBorder = Color(0xFF8B4A8C);
  static const Color inputText = Color(0xFF333333);
  static const Color inputHint = Color(0xFF999999);

  // Button Colors
  static const Color buttonDisabled = Color(0xFF666666);
  static const Color buttonText = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53E3E);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Progress Indicator Colors
  static const Color progressActive = Color(0xFFB85A8F);
  static const Color progressInactive = Color(0x40FFFFFF); // 25% white

  // Accent Colors
  static const Color accent = Color(0xFFE91E63);
  static const Color accentLight = Color(0xFFFF6B9D);
  static const Color accentDark = Color(0xFF880E4F);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientMiddle, gradientEnd],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryPurple, primaryPink],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x40000000), Color(0x80000000)],
  );

  // Material Colors for Theme
  static const MaterialColor primarySwatch =
      MaterialColor(0xFF8B4A8C, <int, Color>{
        50: Color(0xFFF3E5F5),
        100: Color(0xFFE1BEE7),
        200: Color(0xFFCE93D8),
        300: Color(0xFFBA68C8),
        400: Color(0xFFAB47BC),
        500: Color(0xFF8B4A8C),
        600: Color(0xFF8E24AA),
        700: Color(0xFF7B1FA2),
        800: Color(0xFF6A1B9A),
        900: Color(0xFF4A148C),
      });
}
