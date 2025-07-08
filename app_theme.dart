import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blueGrey,
      scaffoldBackgroundColor: Colors.blueGrey[50],
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF62B6CB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 16.0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white.withOpacity(0.9),
      ),
      colorScheme: ColorScheme.light(
        primary: Colors.teal[700]!,
        secondary: Colors.teal[400]!,
        surface: Colors.white,
        background: Colors.blueGrey[50]!,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.blueGrey,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 16.0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal[700],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[800]!.withOpacity(0.9),
      ),
      colorScheme: ColorScheme.dark(
        primary: Colors.teal[400]!,
        secondary: Colors.teal[300]!,
        surface: Colors.grey[800]!,
        background: Colors.grey[900]!,
      ),
    );
  }
}
