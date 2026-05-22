import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {

  String _currency = 'PKR';
  bool _isDarkMode = false;

  String get currency => _currency;
  bool get isDarkMode => _isDarkMode;

  void setCurrency(String val) {
    _currency = val;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void clearAllData() {
    notifyListeners();
  }
}