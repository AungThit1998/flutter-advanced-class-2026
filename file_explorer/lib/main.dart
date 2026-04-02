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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomeScreen(),
      theme: AppTheme.lightTheme(),
      darkTheme: ThemeData.dark(),
    );
  }
}
