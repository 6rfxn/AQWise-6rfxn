import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'app_locale';
  Locale _locale = const Locale('en');
  bool _isInitialized = false;

  Locale get locale => _locale;
  bool get isInitialized => _isInitialized;

  LocaleProvider();

  Future<void> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey) ?? 'en';
      _locale = Locale(languageCode);
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // If fails, use default
      _locale = const Locale('en');
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _saveLocale(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale.languageCode != locale.languageCode) {
      _locale = locale;
      await _saveLocale(locale.languageCode);
      notifyListeners();
    }
  }
}

