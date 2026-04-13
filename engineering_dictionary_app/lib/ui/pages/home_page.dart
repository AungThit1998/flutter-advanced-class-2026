import 'package:engineering_dictionary_app/ui/pages/dictionary_page.dart';
import 'package:engineering_dictionary_app/ui/pages/setting_page.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            activeIcon: Icon(CupertinoIcons.book_fill),
            label: "Dictionary",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            activeIcon: Icon(CupertinoIcons.settings_solid),
            label: "Settings",
          ),
        ],
      ),
      tabBuilder: (_, int index) {
        if (index == 1) {
          return SettingPage();
        }
        return DictionaryPage();
      },
    );
  }
}
