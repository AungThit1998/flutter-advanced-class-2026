import 'package:book_library_database/const/theme/my_theme.dart';
import 'package:book_library_database/data/library_db_service.dart';
import 'package:book_library_database/provider/author_provider.dart';
import 'package:book_library_database/provider/book_provider.dart';
import 'package:book_library_database/view/storage/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LibraryDbService.createDatabase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthorProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: _themeMode,
        theme: MyTheme.lightTheme(),
        darkTheme: MyTheme.darkTheme(),
        home: Home(onThemeChanged: _changeThemeMode),
      ),
    );
  }
}
