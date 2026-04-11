import 'package:book_library_database/const/theme/app_theme_token.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key, required this.onSelected});
  final Function(int) onSelected;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    AppThemeTokens themeTokens = Theme.of(context).extension<AppThemeTokens>()!;
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: themeTokens.navBg,
        indicatorColor: Colors.transparent,
        height: 85,
        labelTextStyle: WidgetStateProperty.resolveWith((state) {
          bool isSelected = state.contains(WidgetState.selected);
          return TextStyle(
            fontSize: isSelected ? 12 : 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? themeTokens.onBackground
                : themeTokens.textSecondary,
          );
        }),
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: themeTokens.border)),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            widget.onSelected(index);
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: [
            _destination(Icon(Icons.folder_open), 'Books'),
            _destination(Icon(Icons.groups), 'Authors'),
            _destination(Icon(Icons.settings), 'Configs'),
          ],
        ),
      ),
    );
  }

  NavigationDestination _destination(Icon icon, String label) {
    AppThemeTokens themeTokens = Theme.of(context).extension<AppThemeTokens>()!;
    final selectedIcon = ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          colors: [themeTokens.primaryLight, themeTokens.secondary],
        ).createShader(rect);
      },
      child: Icon(icon.icon, color: themeTokens.onPrimary, size: 24),
    );
    return NavigationDestination(
      icon: icon,
      selectedIcon: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.9, end: 1.0),
        duration: Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, -2),
            child: Transform.scale(scale: value, child: child),
          );
        },
        child: selectedIcon,
      ),
      label: label,
    );
  }
}
