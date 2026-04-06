import 'package:book_library_database/view/home/widgets/fab.dart';
import 'package:flutter/material.dart';

import 'widgets/bottom_nav.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      floatingActionButton: Fab(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
