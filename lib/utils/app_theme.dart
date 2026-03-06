import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFec5b13);
  static const Color backgroundLight = Color(0xFFf8f6f6);
  static const Color backgroundDark = Color(0xFF221610);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        brightness: Brightness.light,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: GoogleFonts.publicSansTextTheme(ThemeData.light().textTheme),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        shadowColor: Colors.black12,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        brightness: Brightness.dark,
        surface: const Color(0xFF332014),
      ),
      scaffoldBackgroundColor: backgroundDark,
      textTheme: GoogleFonts.publicSansTextTheme(ThemeData.dark().textTheme),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 12,
        color: const Color(0xFF332014),
        shadowColor: Colors.black45,
      ),
    );
  }
}
