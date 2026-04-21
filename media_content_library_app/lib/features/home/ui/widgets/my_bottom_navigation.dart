import 'package:flutter/material.dart';

class MyBottomNavigation extends StatefulWidget {
  const MyBottomNavigation({super.key});

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: [
        NavigationDestination(icon: Icon(Icons.home), label: "Home"),
        NavigationDestination(icon: Icon(Icons.audiotrack), label: "Audio"),
        NavigationDestination(
          icon: Icon(Icons.movie_filter_outlined),
          label: "Video",
        ),
        NavigationDestination(
          icon: Icon(Icons.picture_as_pdf_outlined),
          label: "Pdf",
        ),
        NavigationDestination(icon: Icon(Icons.settings), label: "Settins"),
      ],
    );
  }
}
