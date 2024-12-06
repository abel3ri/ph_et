import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF03624C),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF03624C),
      primaryContainer: Color(0xffa8e6a2),
      secondary: Color(0xff28a745),
      secondaryContainer: Color(0xffb2dfdb),
      tertiary: Color(0xff004d40),
      error: Color(0xffd32f2f),
      surface: Color(0xFFF8F9FA),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8F9FA),
      elevation: 0,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    fontFamily: GoogleFonts.openSans().fontFamily,
    textTheme: const TextTheme(
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF03624C),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
    ),
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    fontFamily: GoogleFonts.openSans().fontFamily,
    textTheme: const TextTheme(
      bodySmall: TextStyle(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
      bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
      bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
      titleSmall: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      headlineSmall: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      headlineLarge: TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF03624C),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF03624C),
      primaryContainer: const Color(0xff6fcf97),
      secondary: const Color(0xff26a69a),
      secondaryContainer: const Color(0xff80cbc4),
      tertiary: const Color(0xff004d40),
      error: const Color(0xffcf6679),
      surface: const Color(0xFF1E1E1E),
    ),
  );
}
