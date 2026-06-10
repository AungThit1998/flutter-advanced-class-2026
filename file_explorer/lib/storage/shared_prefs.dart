import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._();
  static const String themeModeKey = "theme_mode";

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeModeKey, mode.index);
  }

  static Future<ThemeMode> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? themeIndex = prefs.getInt(themeModeKey);
    if (themeIndex == null ||
        themeIndex < 0 ||
        themeIndex >= ThemeMode.values.length) {
      return ThemeMode.system;
    }
    return ThemeMode.values[themeIndex];
  }
}
