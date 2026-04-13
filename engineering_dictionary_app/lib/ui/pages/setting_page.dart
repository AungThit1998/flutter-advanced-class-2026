import 'package:engineering_dictionary_app/providers/engineering_provider.dart';
import 'package:engineering_dictionary_app/providers/theme_provider.dart';
import 'package:engineering_dictionary_app/ui/pages/favourite_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (_, _) {
          return [CupertinoSliverNavigationBar(largeTitle: Text("Settings"))];
        },
        body: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 40),
          children: [
            _SectionLabel('Appearance'),
            _Group([
              Consumer<ThemeProvider>(
                builder: (context, provider, child) {
                  return _ToggleRow(
                    icon: CupertinoIcons.moon_fill,
                    iconBg: const Color(0xFF5E5CE6),
                    label: 'Dark Mode',
                    value: provider.isDark,
                    onChanged: (_) {
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).changeTheme(!provider.isDark);
                    },
                  );
                },
              ),
            ]),

            _SectionLabel('Favourites'),
            _Group([
              _ButtonRow(
                icon: CupertinoIcons.heart_fill,
                iconBg: CupertinoColors.systemRed,
                label: 'Saved Terms',
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => FavouritePage()),
                  );
                },
              ),
              _ButtonRow(
                icon: CupertinoIcons.trash,
                iconBg: CupertinoColors.systemRed,
                label: 'Clear All Favourites',
                destructive: true,
                enabled: true,
                onTap: () => showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: const Text('Clear Favourites'),
                    content: Text('Remove all Favourites'),
                    actions: [
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          Provider.of<EngineeringProvider>(
                            context,
                            listen: false,
                          ).clearAllFAv();
                          Navigator.pop(context);
                        },
                        child: const Text('Clear All'),
                      ),
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ),
            ]),

            _SectionLabel('About'),
            _Group([
              _InfoRow(
                icon: CupertinoIcons.info_circle_fill,
                iconBg: CupertinoColors.activeBlue,
                label: 'Version',
                value: '1.0.0',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 6),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: CupertinoColors.systemGrey,
        letterSpacing: 0.5,
      ),
    ),
  );
}

class _Group extends StatelessWidget {
  final List<Widget> children;

  const _Group(this.children);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemGrey5.resolveFrom(context),
          width: 0.5,
        ),
      ),
      child: Column(
        children: children.asMap().entries.map((e) {
          final last = e.key == children.length - 1;
          return Column(
            children: [
              e.value,
              if (!last)
                Container(
                  height: 0.5,
                  margin: const EdgeInsets.only(left: 52),
                  color: CupertinoColors.systemGrey5.resolveFrom(context),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color bg;

  const _IconBox({required this.icon, required this.bg});

  @override
  Widget build(BuildContext context) => Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(7),
    ),
    child: Icon(icon, color: CupertinoColors.white, size: 16),
  );
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.iconBg,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    child: Row(
      children: [
        _IconBox(icon: icon, bg: iconBg),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
            ],
          ),
        ),
        CupertinoSwitch(value: value, onChanged: onChanged),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label, value;

  const _InfoRow({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    child: Row(
      children: [
        _IconBox(icon: icon, bg: iconBg),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    ),
  );
}

class _ButtonRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final bool destructive, enabled;
  final VoidCallback onTap;

  const _ButtonRow({
    required this.icon,
    required this.iconBg,
    required this.label,
    this.destructive = false,
    this.enabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: enabled ? onTap : null,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          _IconBox(
            icon: icon,
            bg: enabled ? iconBg : CupertinoColors.systemGrey,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: !enabled
                  ? CupertinoColors.systemGrey
                  : destructive
                  ? CupertinoColors.systemRed
                  : CupertinoColors.label.resolveFrom(context),
            ),
          ),
        ],
      ),
    ),
  );
}
