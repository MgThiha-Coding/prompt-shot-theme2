import 'package:flutter/material.dart';

final darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF0F0F0F),
  primaryColor: const Color(0xFF00BCD4),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF00BCD4),
    secondary: Color(0xFFFFC107),
    surface: Color(0xFF1C1C1C),
    error: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white70,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A),
    iconTheme: IconThemeData(color: Color(0xFFFFC107)),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardColor: const Color(0xFF1B1B1B),
  canvasColor: const Color(0xFF262626),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white70),
    bodyMedium: TextStyle(color: Colors.white60),
    bodySmall: TextStyle(color: Colors.white54),
    titleLarge: TextStyle(color: Color(0xFFFFC107)),
    titleMedium: TextStyle(color: Color(0xFF00BCD4)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFC107),
      foregroundColor: Colors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF1A1A1A),
    contentTextStyle: TextStyle(color: Colors.white),
  ),
);
