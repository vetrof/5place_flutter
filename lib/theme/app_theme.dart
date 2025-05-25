import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'Roboto',
    );
  }

  static Color get primaryColor => Colors.blue[600]!;
  static Color get backgroundColor => Colors.grey[50]!;
  static Color get cardColor => Colors.white;
  static Color get textPrimary => Colors.grey[800]!;
  static Color get textSecondary => Colors.grey[600]!;
}