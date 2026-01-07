import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Color(0xFF3573A8),
    surface: Color(0xFFF2F2F7),
    secondary: Color(0xFF8E8E93),
  ),
  useMaterial3: true,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF0A84FF),
    surface: Color(0xFF1C1C1E),
    secondary: Color(0xFF8E8E93),
  ),
  useMaterial3: true,
);