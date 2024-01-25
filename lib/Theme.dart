import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _darkMode = false;
  final String _themeKey = 'theme_preference';

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get darkMode => _darkMode;

  set darkMode(bool value) {
    _darkMode = value;
    _saveThemePreference();
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _darkMode);
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savedTheme = prefs.getBool(_themeKey) ?? false;
    _darkMode = savedTheme;
    notifyListeners();
  }
}

