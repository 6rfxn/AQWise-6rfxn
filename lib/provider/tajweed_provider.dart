import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TajweedProvider with ChangeNotifier {
  // since its for testing store here jela
  final List<String> _tajweedRules = [
    'Izhar',
    'Idgham',
    'Ikhfa',
    'Iqlab',
    'Ghunnah',
    'Qalqalah',
    'Madd',
  ];

  Map<String, String> _savedData = {};
  String? _selectedRule;

  List<String> get tajweedRules => _tajweedRules;
  Map<String, String> get savedData => _savedData;
  String? get selectedRule => _selectedRule;

  TajweedProvider() {
    loadSavedData();
  }

  void selectRule(String? rule) {
    _selectedRule = rule;
    notifyListeners();
  }

  Future<void> confirmSelection(String textKey) async {
    if (_selectedRule != null) {
      _savedData[textKey] = _selectedRule!;
      await _saveToPrefs();
      _selectedRule = null;
      notifyListeners();
    }
  }

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataJson = prefs.getString('tajweed_data');
    if (dataJson != null) {
      _savedData = Map<String, String>.from(json.decode(dataJson));
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tajweed_data', json.encode(_savedData));
  }
}
