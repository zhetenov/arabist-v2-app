import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0B132B);
  static const Color surface = Color(0xFF14213D);
  static const Color accent = Color(0xFF00FFC6);
  static const Color gold = Color(0xFFF4D03F);
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFFA3B3C3);
  static const Color shadow = Colors.black26;

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    useMaterial3: true,

    colorScheme: const ColorScheme.dark(
      primary: accent,
      secondary: gold,
      surface: surface,
      background: background,
      onPrimary: Colors.black,
      onSurface: textPrimary,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
      headlineSmall: TextStyle(
        color: gold,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'ScheherazadeNew',
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),

    cardTheme: const CardThemeData(
      color: surface,
      shadowColor: shadow,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    iconTheme: const IconThemeData(color: accent, size: 22),

    dividerTheme: const DividerThemeData(
      color: Color(0xFF1F2A45),
      thickness: 0.8,
    ),
  );
}
