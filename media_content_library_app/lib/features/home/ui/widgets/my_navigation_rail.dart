import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../const/responsive/responsive_utils.dart';

class MyNavigationRail extends StatelessWidget {
  const MyNavigationRail({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveUtils.isDesktop(context);
    return Row(
      children: [
        NavigationRail(
          extended: isDesktop,
          labelType: isDesktop
              ? NavigationRailLabelType.none
              : NavigationRailLabelType.all,
          destinations: [
            NavigationRailDestination(
              icon: Icon(Icons.home),
              label: Text("Home"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.audiotrack),
              label: Text("Audio"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.movie_filter_outlined),
              label: Text("Video"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.picture_as_pdf_outlined),
              label: Text("Pdf"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings),
              label: Text("Settings"),
            ),
          ],
          selectedIndex: shell.currentIndex,
          onDestinationSelected: (index) => shell.goBranch(index),
        ),
        VerticalDivider(),
      ],
    );
  }
}
