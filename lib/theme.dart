import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.brown,
    scaffoldBackgroundColor: const Color(0xFFF5F0E6),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF5D4037),
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
    ),
  );
}