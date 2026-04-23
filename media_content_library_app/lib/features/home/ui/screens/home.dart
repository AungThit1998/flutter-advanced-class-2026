import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_content_library_app/features/blog/ui/screens/blog_screen.dart';
import 'package:media_content_library_app/features/home/ui/widgets/my_bottom_navigation.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Content Media Application"),
        centerTitle: true,
      ),
      body: widget.shell,
      bottomNavigationBar: MyBottomNavigation(shell: widget.shell),
    );
  }
}
