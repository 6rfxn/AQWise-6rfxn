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

  Map<String, List<String>> _savedData = {};

  List<String> get tajweedRules => _tajweedRules;
  Map<String, List<String>> get savedData => _savedData;

  TajweedProvider() {
    load();
  }

  Future<void> confirmSelection(String textKey, List<String> rules) async {
    if (rules.isEmpty) {
      _savedData.remove(textKey);
    } else {
      _savedData[textKey] = rules;
    }
    await _save();
    notifyListeners();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataJson = prefs.getString('tajweed_data');
    if (dataJson != null) {
      print(dataJson);
      final decoded = json.decode(dataJson) as Map<String, dynamic>;
      _savedData = decoded.map((key, value) {
        if (value is List) {
          return MapEntry(key, List<String>.from(value));
        }
        if (value is String) {
          return MapEntry(key, <String>[value]);
        }
        return MapEntry(key, <String>[]);
      });
      notifyListeners();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tajweed_data', json.encode(_savedData));
  }
}
