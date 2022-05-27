import 'package:flutter/material.dart';
import 'package:flutter_lab/controllers/theme_preference.dart';

import '../l10n/l10n.dart';

class ThemeModel extends ChangeNotifier {
  late bool _isDark;
  late ThemePreferences _preferences;
  late Locale _locale;

  Locale get locale => _locale;
  bool get isDark => _isDark;

  ThemeModel() {
    _isDark = false;
    _locale = Locale('en');
    _preferences = ThemePreferences();
    getPreferences();
  }

  set isDark(bool value) {
    _isDark = value;
    _preferences.setThemeColor(value);
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    _preferences.setThemeLocale(locale.languageCode);
    notifyListeners();
  }

  getPreferences() async {
    String code = await _preferences.getThemeLocale();
    _locale = Locale(code);
    _isDark = await _preferences.getThemeColor();
    notifyListeners();
  }

  void clearLocale() {
    _locale = Locale('en');
    notifyListeners();
  }
}