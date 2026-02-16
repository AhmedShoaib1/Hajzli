import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');
  ThemeMode _themeMode = ThemeMode.light;
  bool _isDark = false;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _isDark;

  SettingsProvider() {
    _loadSettings();
  }

  // تحميل الإعدادات من SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language_code') ?? 'ar';
    _locale = Locale(langCode);
    _isDark = prefs.getBool('is_dark') ?? false;
    _themeMode = _isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // تغيير اللغة وحفظها
  Future<void> changeLanguage(String languageCode) async {
    if (_locale.languageCode == languageCode) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // تبديل الوضع الداكن/الفاتح
  Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark', isDark);
    _isDark = isDark;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
