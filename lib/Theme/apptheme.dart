// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

// --- COLOR PALETTE ---
// Based on Dashboard design
final Color primaryBlue = const Color(0xFF0D63D1); 
final Color successGreen = const Color(0xFF00B167); 
final Color backgroundLight = const Color(0xFFF4F7FA); 
final Color surfaceWhite = Colors.white;
final Color textDark = const Color(0xFF1A1C1E);
final Color textGrey = const Color(0xFF6C757D);
final Color containerPurple = const Color(0xFF9735FF);
final Color containerOrange = const Color(0xFFFF5700);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: backgroundLight,

  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryBlue,
    primary: primaryBlue,
    secondary: successGreen,
    surface: surfaceWhite,
    background: backgroundLight,
    tertiary: containerPurple,
    errorContainer: containerOrange, // Used for support/warning actions
  ),

  // ✨ REFACTORED TYPOGRAPHY SYSTEM
  // Based on "Welcome back" and Portfolio Value styling
  textTheme: TextTheme(
    // Portfolio Value Large Number (₹13,45,000)
    headlineLarge: TextStyle(
      color: surfaceWhite,
      fontSize: 34,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.0,
    ),
    // Section Headers ("Quick Actions", "My Investments")
    headlineSmall: TextStyle(
      color: textDark,
      fontSize: 20,
      fontWeight: FontWeight.w800,
    ),
    // User Name ("Rahul Sharma")
    titleLarge: TextStyle(
      color: surfaceWhite,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    // Card Main Labels ("Invested", "Returns")
    titleMedium: TextStyle(
      color: textGrey,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    // Sub-labels ("Welcome back", "Total Portfolio Value")
    bodyMedium: TextStyle(
      color: textGrey,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    // Footer Labels / Table Headers
    labelSmall: TextStyle(
      color: textGrey,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      textBaseline: TextBaseline.alphabetic,
    ),
  ),

  // 🧊 REFACTORED CARD THEME
  // Matching the 24px radius and soft shadow seen in
  cardTheme: CardThemeData(
    color: surfaceWhite,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  ),

  // 🔘 REFACTORED BUTTON THEME
  // For the "Logout" button design
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFD8D8), // Light red bg
      foregroundColor: const Color(0xFFE53935), // Dark red text
      elevation: 0,
      minimumSize: const Size(double.infinity, 54),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),

  // 🧭 BOTTOM NAVIGATION BAR
  // Matching the blue/grey active/inactive state
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: surfaceWhite,
    selectedItemColor: primaryBlue,
    unselectedItemColor: textGrey,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
    elevation: 10,
    selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    unselectedLabelStyle: const TextStyle(fontSize: 12),
  ),

  // 📎 INPUT DECORATION (For Search Bars in)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFE9ECEF),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: textGrey, fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
);