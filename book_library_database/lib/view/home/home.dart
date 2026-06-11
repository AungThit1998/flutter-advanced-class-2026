import 'package:book_library_database/view/home/author_page.dart';
import 'package:book_library_database/view/home/book_page.dart';
import 'package:book_library_database/view/home/config_page.dart';
import 'package:book_library_database/view/home/widgets/add_author_sheet.dart';
import 'package:book_library_database/view/home/widgets/add_book_sheet.dart';
import 'package:book_library_database/view/home/widgets/fab.dart';
import 'package:flutter/material.dart';

import 'widgets/bottom_nav.dart';

class Home extends StatefulWidget {
  final ValueChanged<ThemeMode> onThemeChanged;

  const Home({super.key, required this.onThemeChanged});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (_index == 0 || _index == 1)
          ? Fab(
              onPress: () {
                if (_index == 0) {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return AddBookSheet();
                    },
                  );
                } else if (_index == 1) {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return AddAuthorSheet();
                    },
                  );
                }
              },
            )
          : null,
      body: switch (_index) {
        0 => BookPage(),
        1 => AuthorPage(),
        2 => ConfigPage(onThemeChanged: widget.onThemeChanged),
        _ => SizedBox(),
      },
      bottomNavigationBar: BottomNav(
        onSelected: (int index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
