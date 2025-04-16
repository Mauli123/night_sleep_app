import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color palette
  static const Color deepNavy = Color(0xFF0A0F24);
  static const Color midnightBlue = Color(0xFF1A2151);
  static const Color lavender = Color(0xFF9C92CB);
  static const Color softPurple = Color(0xFF7E6BC4);
  static const Color softBlue = Color(0xFF6B9AC4);
  static const Color softPink = Color(0xFFC49CC7);
  static const Color textLight = Color(0xFFF5F5F7);
  static const Color textDim = Color(0xFFBBBBCC);
  
  // Rounded corner radius
  static const double borderRadius = 16.0;
  
  // Elevation for cards and buttons
  static const double cardElevation = 4.0;
  
  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Light Theme (though we'll primarily use dark theme)
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: softPurple,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: _buildTextTheme(isDark: false),
      colorScheme: ColorScheme.light(
        primary: softPurple,
        secondary: softBlue,
        background: Colors.white,
        surface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: deepNavy),
        titleTextStyle: GoogleFonts.poppins(
          color: deepNavy,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: softPurple,
          foregroundColor: Colors.white,
          elevation: 4,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  
  // Dark Theme (primary theme for the app)
  static ThemeData darkTheme() {
    return ThemeData(
      primaryColor: softPurple,
      scaffoldBackgroundColor: deepNavy,
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: _buildTextTheme(isDark: true),
      colorScheme: ColorScheme.dark(
        primary: softPurple,
        secondary: softBlue,
        background: deepNavy,
        surface: midnightBlue,
        onBackground: textLight,
        onSurface: textLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: deepNavy,
        elevation: 0,
        iconTheme: IconThemeData(color: textLight),
        titleTextStyle: GoogleFonts.poppins(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: midnightBlue,
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: softPurple,
          foregroundColor: textLight,
          elevation: 4,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: textLight,
        size: 24,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: midnightBlue,
        selectedItemColor: softPurple,
        unselectedItemColor: textDim,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: softPurple,
        inactiveTrackColor: textDim.withOpacity(0.3),
        thumbColor: softPurple,
        overlayColor: softPurple.withOpacity(0.2),
        trackHeight: 4,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return softPurple;
          }
          return textDim;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return softPurple.withOpacity(0.5);
          }
          return textDim.withOpacity(0.3);
        }),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: midnightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
  
  // Text theme builder
  static TextTheme _buildTextTheme({required bool isDark}) {
    final Color textColor = isDark ? textLight : deepNavy;
    final Color textSecondary = isDark ? textDim : deepNavy.withOpacity(0.7);
    
    return TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }
}
