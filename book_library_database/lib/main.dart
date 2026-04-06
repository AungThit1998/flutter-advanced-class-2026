import 'package:book_library_database/const/theme/my_theme.dart';
import 'package:book_library_database/data/library_db_service.dart';
import 'package:flutter/material.dart';

import 'view/home/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LibraryDbService.createDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: MyTheme.lightTheme(),
      darkTheme: MyTheme.darkTheme(),
      home: const Home(),
    );
  }
}

