import 'package:flutter/material.dart';

@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  const AppThemeTokens({
    required this.primary,
    required this.primaryLight,
    required this.secondary,
    required this.onPrimary,
    required this.background,
    required this.surface,
    required this.onBackground,
    required this.textSecondary,
    required this.border,
    required this.navBg,
    required this.backBtnBg,
    required this.backBtnBorder,
    required this.dbPlaceholderGradient,
    required this.tagBackground,
    required this.tagText,
    required this.scrim,
    required this.shadow,
  });

  final Color primary;
  final Color primaryLight;
  final Color secondary;
  final Color onPrimary;
  final Color background;
  final Color surface;
  final Color onBackground;
  final Color textSecondary;
  final Color border;
  final Color navBg;
  final Color backBtnBg;
  final Color backBtnBorder;
  final Gradient dbPlaceholderGradient;
  final Color tagBackground;
  final Color tagText;
  final Color scrim;
  final Color shadow;

  static const dark = AppThemeTokens(
    primary: Color(0xFF8A2BE2),
    primaryLight: Color(0xFFB47CFF),
    secondary: Color(0xFFFF2A75),
    onPrimary: Colors.white,
    background: Color(0xFF0F1016),
    surface: Color(0x0DFFFFFF),
    onBackground: Colors.white,
    textSecondary: Color(0xFFA0A5B1),
    border: Color(0x14FFFFFF),
    navBg: Color(0xD90F1016),
    backBtnBg: Color(0x4D000000),
    backBtnBorder: Color(0x1AFFFFFF),
    dbPlaceholderGradient: LinearGradient(
      colors: [Color(0xFF1A1A24), Color(0xFF2A2A35)],
    ),
    tagBackground: Color(0x268A2BE2),
    tagText: Color(0xFFB47CFF),
    scrim: Color(0x99000000),
    shadow: Color(0x66000000),
  );

  static const light = AppThemeTokens(
    primary: Color(0xFF6B21A8),
    primaryLight: Color(0xFF9333EA),
    secondary: Color(0xFFE11D48),
    onPrimary: Colors.white,
    background: Color(0xFFF8F9FA),
    surface: Color(0x08000000),
    onBackground: Color(0xFF111827),
    textSecondary: Color(0xFF6B7280),
    border: Color(0x0F000000),
    navBg: Color(0xD9FFFFFF),
    backBtnBg: Color(0xB3FFFFFF),
    backBtnBorder: Color(0x1A000000),
    dbPlaceholderGradient: LinearGradient(
      colors: [Color(0xFFE5E7EB), Color(0xFFF3F4F6)],
    ),
    tagBackground: Color(0x1A6B21A8),
    tagText: Color(0xFF6B21A8),
    scrim: Color(0x80000000),
    shadow: Color(0x33000000),
  );

  @override
  ThemeExtension<AppThemeTokens> copyWith() {
    return AppThemeTokens(
      primary: primary,
      primaryLight: primaryLight,
      secondary: secondary,
      onPrimary: onPrimary,
      background: background,
      surface: surface,
      onBackground: onBackground,
      textSecondary: textSecondary,
      border: border,
      navBg: navBg,
      backBtnBg: backBtnBg,
      backBtnBorder: backBtnBorder,
      dbPlaceholderGradient: dbPlaceholderGradient,
      tagBackground: tagBackground,
      tagText: tagText,
      scrim: scrim,
      shadow: shadow,
    );
  }

  @override
  ThemeExtension<AppThemeTokens> lerp(
    covariant ThemeExtension<AppThemeTokens>? other,
    double t,
  ) {
    return AppThemeTokens(
      primary: primary,
      primaryLight: primaryLight,
      secondary: secondary,
      onPrimary: onPrimary,
      background: background,
      surface: surface,
      onBackground: onBackground,
      textSecondary: textSecondary,
      border: border,
      navBg: navBg,
      backBtnBg: backBtnBg,
      backBtnBorder: backBtnBorder,
      dbPlaceholderGradient: dbPlaceholderGradient,
      tagBackground: tagBackground,
      tagText: tagText,
      scrim: scrim,
      shadow: shadow,
    );
  }
}
