import 'package:flutter/material.dart';

final darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF0F0F0F), // Background for scaffold
  primaryColor: const Color(0xFF00BCD4), // Primary brand color
  canvasColor: const Color(0xFF262626), // Background for Drawer, menus, etc.
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF262626), // Drawer background color
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF00BCD4),
    secondary: Color(0xFFFFC107),
    surface: Color(0xFF1C1C1C), // Cards, DrawerHeader background, etc.
    error: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white70,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A), // AppBar background
    iconTheme: IconThemeData(color: Color(0xFFFFC107)), // Icons color
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardColor: const Color(0xFF1B1B1B), // Cards background color
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white70),
    bodyMedium: TextStyle(color: Colors.white60),
    bodySmall: TextStyle(color: Colors.white54),
    titleLarge: TextStyle(color: Color(0xFFFFC107)), // Headlines color
    titleMedium: TextStyle(color: Color(0xFF00BCD4)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFC107), // Button background
      foregroundColor: Colors.black, // Button text/icon color
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF1A1A1A),
    contentTextStyle: TextStyle(color: Colors.white),
  ),
);
