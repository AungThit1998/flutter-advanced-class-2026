import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_content_library_app/const/responsive/responsive_utils.dart';
import 'package:media_content_library_app/features/blog/ui/screens/blog_screen.dart';
import 'package:media_content_library_app/features/home/ui/widgets/my_bottom_navigation.dart';
import 'package:media_content_library_app/features/home/ui/widgets/my_navigation_rail.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveUtils.isMobile(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Content Media Application"),
        centerTitle: true,
      ),
      body: Row(
        children: [
          if (!isMobile)
            MyNavigationRail(shell: widget.shell),
          Expanded(child: widget.shell),
        ],
      ),
      bottomNavigationBar: isMobile
          ? MyBottomNavigation(shell: widget.shell)
          : null,
    );
  }
}
