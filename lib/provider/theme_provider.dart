import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_data';
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider();

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
      print(_isDarkMode);
    } catch (e) {
      _isDarkMode = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _save(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, value);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  Future<void> toggle() async {
    _isDarkMode = !_isDarkMode;
    await _save(_isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      await _save(_isDarkMode);
      notifyListeners();
    }
  }
}
