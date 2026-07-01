import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _verde       = Color(0xFF2D5A27);
  static const Color _verdeOscuro = Color(0xFF1A3A17);
  static const Color _verdeClaro  = Color(0xFF4A8F42);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _verde,
      primary: _verde,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _verdeOscuro,
      foregroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _verdeClaro,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _verde,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _verde,
        side: const BorderSide(color: _verde),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
    chipTheme: ChipThemeData(
      selectedColor: _verde,
      labelStyle: const TextStyle(fontSize: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
    ),
  );
}
