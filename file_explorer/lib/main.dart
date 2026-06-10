import 'package:file_explorer/storage/shared_prefs.dart';
import 'package:file_explorer/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'home/home_screen.dart';

// pre android 5 lp (permission)
// 5 - 8 [permission]
//8 - 10 [permission] restrict
//

//picker [SAF- FP]

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final themeMode = await SharedPrefs.getThemeMode();
    if (!mounted) return;
    setState(() {
      _themeMode = themeMode;
    });
  }

  Future<void> _changeThemeMode(ThemeMode themeMode) async {
    setState(() {
      _themeMode = themeMode;
    });
    await SharedPrefs.saveThemeMode(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomeScreen(themeMode: _themeMode, onThemeChanged: _changeThemeMode),
      theme: AppTheme.lightTheme(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
    );
  }
}
