import 'package:flutter/material.dart';


ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF10B981), // emerald-500
    primaryContainer: const Color(0xFF0D9488), // teal-600
    secondary: const Color(0xFF8E8E93),
    surface: const Color(0xFFF2F2F7),
    onSurface: const Color(0xFF1C1C1E),
    outline: const Color(0xFFE5E5EA),
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.transparent,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    foregroundColor: Color(0xFF1C1C1E),
  ),
  cardTheme: CardThemeData(
    color: Colors.white.withValues(alpha: 0.8),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF10B981), // emerald-500
    primaryContainer: const Color(0xFF0D9488), // teal-600
    secondary: const Color(0xFF8E8E93),
    surface: const Color(0xFF1C1C1E),
    onSurface: Colors.white,
    outline: Colors.white.withValues(alpha: 0.1),
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.transparent,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    foregroundColor: Colors.white,
  ),
  cardTheme: CardThemeData(
    color: Colors.white.withValues(alpha: 0.08),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
    ),
  ),
);

