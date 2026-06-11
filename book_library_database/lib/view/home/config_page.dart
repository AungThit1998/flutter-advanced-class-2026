import 'package:book_library_database/const/theme/app_theme_token.dart';
import 'package:book_library_database/view/home/fav_author_page.dart';
import 'package:flutter/material.dart';
import 'package:book_library_database/view/home/fav_book_page.dart';

class ConfigPage extends StatefulWidget {
  final ValueChanged<ThemeMode> onThemeChanged;
  const ConfigPage({super.key, required this.onThemeChanged});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    AppThemeTokens themeTokens = Theme.of(context).extension<AppThemeTokens>()!;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: themeTokens.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.dark_mode, color: themeTokens.primary),
                    ),
                  ),
                  title: Text('Theme Mode'),
                  subtitle: Text('Light theme enabled'),
                  trailing: InkWell(
                    onTap: () {
                      widget.onThemeChanged(
                        isDarkMode ? ThemeMode.light : ThemeMode.dark,
                      );
                    },
                    child: isDarkMode
                        ? Icon(
                            Icons.toggle_on,
                            size: 50,
                            color: themeTokens.primary,
                          )
                        : Icon(
                            Icons.toggle_off_outlined,
                            size: 50,
                            color: themeTokens.primary,
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: ((context) => FavBookPage())),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: themeTokens.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Icon(Icons.favorite, color: themeTokens.primary),
                      ),
                    ),
                    title: Text('Favorite Books'),
                    subtitle: Text('Quick access to starred titles'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: ((context) => FavAuthorPage())),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: themeTokens.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Icon(Icons.star, color: themeTokens.primary),
                      ),
                    ),
                    title: Text('Favorite Authors'),
                    subtitle: Text('Saved Profile and Notes'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
