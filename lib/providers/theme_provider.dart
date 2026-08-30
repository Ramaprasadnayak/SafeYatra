import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  ThemeProvider() {
    loadTheme();
  }
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    int theme = prefs.getInt("theme") ?? 1;
    _themeMode =theme == 0 ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
  Future<void> setTheme(ThemeMode mode) async { 
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      "theme",
      mode == ThemeMode.dark ? 1 : 0,
    );
    notifyListeners();
  }
}