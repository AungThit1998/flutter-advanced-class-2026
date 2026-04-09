import 'package:book_library_database/const/theme/my_theme.dart';
import 'package:book_library_database/data/library_db_service.dart';
import 'package:book_library_database/provider/author_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LibraryDbService.createDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthorProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: MyTheme.lightTheme(),
        darkTheme: MyTheme.darkTheme(),
        home: const Home(),
      ),
    );
  }
}
