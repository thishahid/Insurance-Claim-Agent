import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkBackground = Color(0xFF121212);
  static const Color oliveGreen = Color(0xFF556B2F);
  static const Color lightOlive = Color(0xFF6B8E23);
  static const Color accentGreen = Color(0xFF8FBC8F);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFFE0E0E0);
  static const Color textDark = Color(0xFFBDBDBD);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: oliveGreen,
      scaffoldBackgroundColor: darkBackground,
      cardColor: cardBackground,
      dividerColor: Colors.grey.shade800,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: textLight),
        titleTextStyle: TextStyle(color: textLight, fontSize: 20),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textLight),
        bodyMedium: TextStyle(color: textDark),
        titleLarge: TextStyle(color: textLight, fontWeight: FontWeight.bold),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: textDark),
        labelStyle: TextStyle(color: lightOlive),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: oliveGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
