import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
      fontFamily: 'SF Pro Display', // можно указать Roboto или скачать SF Pro
    );
  }

  static Color get primaryColor => const Color(0xFF3366FF);
  static Color get backgroundColor => const Color(0xFFF7F7F7);
  static Color get cardColor => Colors.white;
  static Color get cardIconColor => Colors.grey;
  static Color get textPrimary => const Color(0xFF1E1E1E);
  static Color get textSecondary => const Color(0xFF6B7280);
  static Color get accentColor => const Color(0xFF10B981); // зелёный акцент
}
