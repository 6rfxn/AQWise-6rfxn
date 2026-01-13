import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'locale_data';
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  LocaleProvider();

  Future<void> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final langCode = prefs.getString(_localeKey) ?? 'en';
      _locale = Locale(langCode);
    } catch (e) {
      _locale = const Locale('en');
    } finally {
      notifyListeners();
    }
  }

  Future<void> _save(String langCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, langCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale.languageCode != locale.languageCode) {
      _locale = locale;
      await _save(locale.languageCode);
      notifyListeners();
    }
  }
}

