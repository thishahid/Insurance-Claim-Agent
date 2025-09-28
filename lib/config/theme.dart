import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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

  // Create a separate method for markdown styles
  static MarkdownStyleSheet get markdownStyleSheet {
    return MarkdownStyleSheet.fromTheme(ThemeData.dark()).copyWith(
      p: TextStyle(color: textLight, height: 1.5),
      h1: TextStyle(
        color: lightOlive,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      h2: TextStyle(
        color: lightOlive,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      h3: TextStyle(
        color: lightOlive,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      h4: TextStyle(
        color: lightOlive,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      h5: TextStyle(
        color: lightOlive,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      h6: TextStyle(
        color: lightOlive,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      strong: TextStyle(color: textLight, fontWeight: FontWeight.bold),
      em: TextStyle(color: textLight, fontStyle: FontStyle.italic),
      code: TextStyle(
        color: accentGreen,
        backgroundColor: darkBackground,
        fontFamily: 'monospace',
      ),
      codeblockDecoration: BoxDecoration(
        color: darkBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: oliveGreen.withValues(alpha: 0.3)),
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(left: BorderSide(color: oliveGreen, width: 4)),
        color: cardBackground,
      ),
      blockquote: TextStyle(color: textDark, fontStyle: FontStyle.italic),
      listBullet: TextStyle(color: lightOlive),
      checkbox: TextStyle(color: lightOlive),
      tableBorder: TableBorder.all(color: oliveGreen.withValues(alpha: 0.3)),
      tableHead: TextStyle(color: lightOlive, fontWeight: FontWeight.bold),
      tableBody: TextStyle(color: textLight),
    );
  }
}
