import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Color(0xFF6200EE), // Purple
      hintColor: Color(0xFF03DAC6), // Teal
      scaffoldBackgroundColor: Color(0xFFF5F5F5), // Light gray
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF6200EE),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.poppins(fontSize: 18),
        bodyMedium: GoogleFonts.poppins(fontSize: 16),
        bodySmall: GoogleFonts.poppins(fontSize: 14),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
