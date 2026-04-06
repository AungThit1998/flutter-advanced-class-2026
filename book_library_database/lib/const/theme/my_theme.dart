import 'package:flutter/material.dart';

import 'app_theme_token.dart';

class MyTheme {
  static ThemeData lightTheme(){
    return ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light(
        surface: Color(0xFFF8F9FA),
        onSurface: Color(0xFF111827),
        primary: Color(0xFF6B21A8),
        primaryContainer: Color(0xFF9333EA),
        secondary: Color(0xFFE11D48),
        onSurfaceVariant: Color(0xFF6B7280), // For text-secondary
      ),
      scaffoldBackgroundColor: Color(0xFFF8F9FA),
      extensions: const <ThemeExtension<dynamic>>[
        AppThemeTokens.light,
      ],
    );
  }
  static ThemeData darkTheme(){
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        surface: Color(0xFF0F1016),
        onSurface: Colors.white,
        primary: Color(0xFF8A2BE2),
        primaryContainer: Color(0xFFB47CFF),
        secondary: Color(0xFFFF2A75),
        onSurfaceVariant: Color(0xFFA0A5B1), // For text-secondary
      ),
      scaffoldBackgroundColor: Color(0xFF0F1016),
      extensions: const <ThemeExtension<dynamic>>[
        AppThemeTokens.dark,
      ],
    );
  }
}