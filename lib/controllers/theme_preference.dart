import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const PREF_COLOR_KEY = "pref_color";
  static const PREF_LOCALE_KEY = "pref_locale";

  setThemeColor(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(PREF_COLOR_KEY, value);
  }

  getThemeColor() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(PREF_COLOR_KEY) ?? false;
  }

  setThemeLocale(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(PREF_LOCALE_KEY, value);
  }

  getThemeLocale() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(PREF_LOCALE_KEY) ?? 'en';
  }
}