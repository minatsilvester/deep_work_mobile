import 'package:flutter/material.dart';

final ThemeData defaultTheme = ThemeData(
  brightness: Brightness.dark, // Dark theme
  scaffoldBackgroundColor:
      const Color(0xFF2C2C2C), // Moderately dark background (Charcoal)
  primaryColor: const Color(0xFF4CAF50), // Pleasant shade of green (Emerald)
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF4CAF50), // Green primary color
    secondary: Color(0xFF4CAF50), // Green secondary color
    onPrimary: Color(0xFFE0E0E0), // Off-white text on primary color
    onSecondary: Color(0xFFE0E0E0), // Off-white text on secondary color
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Color(0xFFE0E0E0), // Off-white text for large body text
    ),
    bodyMedium: TextStyle(
      color: Color(0xFFE0E0E0), // Off-white text for medium body text
    ),
    bodySmall: TextStyle(
      color: Color(0xFFE0E0E0), // Off-white text for small body text
    ),
    titleLarge: TextStyle(
      color: Color(0xFFE0E0E0), // Off-white text for large titles
    ),
    titleMedium: TextStyle(
      color: Color(0xFFE0E0E0), // Off-white text for medium titles
    ),
    titleSmall: TextStyle(
      color: Color(0xFFE0E0E0), // Off-white text for small titles
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF4CAF50), // Green button color
    textTheme: ButtonTextTheme.primary,
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF2C2C2C), // Dark app bar matching background
    iconTheme:
        IconThemeData(color: Color(0xFFE0E0E0)), // White icons in app bar
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF4CAF50), // Green FAB color
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF2C2C2C), // Dark bottom nav bar
    selectedItemColor: Color(0xFF4CAF50), // Green selected item color
    unselectedItemColor: Color(0xFFE0E0E0), // Light text for unselected items
  ),
);
