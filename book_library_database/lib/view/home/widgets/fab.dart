import 'package:book_library_database/const/theme/app_theme_token.dart';
import 'package:flutter/material.dart';

class Fab extends StatefulWidget {
  const Fab({super.key});

  @override
  State<Fab> createState() => _FabState();
}

class _FabState extends State<Fab> {
  @override
  Widget build(BuildContext context) {
    AppThemeTokens themeTokens = Theme.of(context).extension<AppThemeTokens>()!;
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [themeTokens.primary, themeTokens.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(Icons.add, color: themeTokens.onPrimary, size: 28),
    );
  }
}
