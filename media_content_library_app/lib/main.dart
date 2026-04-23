import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/const/di/locator.dart';
import 'package:media_content_library_app/const/router/router.dart';

import 'features/home/ui/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(title: 'Flutter Demo',
       routerConfig: myRoutes,
    );
  }
}
