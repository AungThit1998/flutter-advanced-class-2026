import 'package:engineering_dictionary_app/database/db_service.dart';
import 'package:engineering_dictionary_app/providers/detail_provider.dart';
import 'package:engineering_dictionary_app/providers/favourite_provider.dart';
import 'package:engineering_dictionary_app/providers/theme_provider.dart';
import 'package:engineering_dictionary_app/ui/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'providers/engineering_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EngineeringProvider()),
        ChangeNotifierProvider(create: (_) => DetailProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Builder(
        builder: (context) {
          return Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              final isDark = provider.isDark;
              final bg = isDark
                  ? const Color(0xFF1C1C1E)
                  : const Color(0xFFF2F2F7);
              return CupertinoApp(
                debugShowCheckedModeBanner: false,
                home: HomePage(),

                theme: CupertinoThemeData(
                  brightness: isDark ? Brightness.dark : Brightness.light,
                  scaffoldBackgroundColor: bg,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
