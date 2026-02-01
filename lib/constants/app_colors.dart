import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(
    0xFF0A0F1A,
  ); // Dark background from main.dart
  static const Color accent = Colors.blueAccent;
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color cardBackground = Colors.white12;

  // Standardized UI Colors
  static final Color borderSubtle = Colors.white.withValues(alpha: 0.15);
  static final Color borderAccent = Colors.blueAccent.withValues(alpha: 0.3);
  static final Color floatingButtonBackground = Colors.blueAccent.withValues(
    alpha: 0.8,
  );
  static const Color floatingButtonIcon = Colors.white;

  // Tech colors (placeholders)
  static const Color flutter = Color(0xFF02569B);
  static const Color ios = Color(0xFF000000); // Usually black or white
  static const Color android = Color(0xFF3DDC84);
  static const Color react = Color(0xFF61DAFB);
  static const Color firebase = Color(0xFFFFCA28);
}
