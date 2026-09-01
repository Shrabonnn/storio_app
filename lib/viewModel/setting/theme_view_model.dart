import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storio_app/utils/theme/app_theme.dart';

enum AppThemeType { defaultTheme, emerald, cosmic }

class ThemeProvider extends ChangeNotifier {
  final AppTheme _appTheme = AppTheme();
  static const String _prefKey = 'selected_theme';

  AppThemeType _selectedTheme = AppThemeType.defaultTheme;
  AppThemeType get selectedTheme => _selectedTheme;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get currentTheme {
    switch (_selectedTheme) {
      case AppThemeType.defaultTheme:
        return _appTheme.light;
      case AppThemeType.emerald:
        return _appTheme.emeraldGreen;
      case AppThemeType.cosmic:
        return _appTheme.dark;
    }
  }

  // App চালু হওয়ার সময় saved theme load করা
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt(_prefKey);
    if (savedIndex != null && savedIndex < AppThemeType.values.length) {
      _selectedTheme = AppThemeType.values[savedIndex];
      notifyListeners();
    }
  }

  // Theme change হলে save করা
  Future<void> setTheme(AppThemeType type) async {
    if (_selectedTheme == type) return;
    _selectedTheme = type;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, type.index);
  }
}