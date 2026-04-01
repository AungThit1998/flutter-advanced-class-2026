import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'file_edit_page.dart';
import 'file_view_page.dart';
import '../theme/theme_scope.dart';

class FileExplorerPage extends StatefulWidget {
  const FileExplorerPage({super.key});

  @override
  State<FileExplorerPage> createState() => _FileExplorerPageState();
}

class _FileExplorerPageState extends State<FileExplorerPage> {
  Directory? _rootDir;
  Directory? _currentDir;
  List<_EntryItem> _items = const [];

  bool _loading = true;
  Object? _error;

  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _initRoot();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initRoot() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final lessonDir = Directory(p.join(documentsDir.path, 'lesson_files'));
      if (!await lessonDir.exists()) {
        await lessonDir.create(recursive: true);
      }

      if (!mounted) return;
      _rootDir = lessonDir;
      _currentDir = lessonDir;
      await _refresh();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _refresh() async {
    final current = _currentDir;
    if (current == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final listed = await current.list(followLinks: false).toList();
      listed.sort((a, b) {
        final aIsDir = a is Directory;
        final bIsDir = b is Directory;
        if (aIsDir != bIsDir) return aIsDir ? -1 : 1;

        final aName = p.basename(a.path).toLowerCase();
        final bName = p.basename(b.path).toLowerCase();
        return aName.compareTo(bName);
      });

      final stats = await Future.wait(
        listed.map((e) async {
          try {
            return await e.stat();
          } catch (_) {
            return null;
          }
        }),
      );

      final items = <_EntryItem>[];
      for (var i = 0; i < listed.length; i++) {
        final entity = listed[i];
        final stat = stats[i];
        items.add(
          _EntryItem(
            entity: entity,
            name: p.basename(entity.path),
            isDir: entity is Directory,
            modified: stat?.modified,
            sizeBytes: entity is File ? stat?.size : null,
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  bool get _canGoUp {
    final root = _rootDir;
    final current = _currentDir;
    if (root == null || current == null) return false;
    if (p.equals(root.path, current.path)) return false;
    return true;
  }

  Future<void> _goUp() async {
    if (!_canGoUp) return;
    final current = _currentDir!;
    final parent = current.parent;
    final root = _rootDir;
    if (root == null) return;
    final allowed =
        p.isWithin(root.path, parent.path) || p.equals(root.path, parent.path);
    if (!allowed) return;

    setState(() => _currentDir = parent);
    await _refresh();
  }

  String _relativePath(Directory dir) {
    final root = _rootDir;
    if (root == null) return dir.path;
    final rel = p.relative(dir.path, from: root.path);
    if (rel == '.') return '/';
    return '/$rel';
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatBytes(int bytes) {
    const k = 1024;
    if (bytes < k) return '$bytes B';
    final kb = bytes / k;
    if (kb < k) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / k;
    if (mb < k) return '${mb.toStringAsFixed(1)} MB';
    final gb = mb / k;
    return '${gb.toStringAsFixed(1)} GB';
  }

  String _formatModified(DateTime? dt, BuildContext context) {
    if (dt == null) return '';
    final local = dt.toLocal();
    final loc = MaterialLocalizations.of(context);
    final date = loc.formatShortDate(local);
    final time = loc.formatTimeOfDay(
      TimeOfDay.fromDateTime(local),
      alwaysUse24HourFormat: false,
    );
    return '$date • $time';
  }

  bool _isValidSingleName(String name) {
    if (name.trim().isEmpty) return false;
    if (name == '.' || name == '..') return false;
    if (name.contains('/') || name.contains('\\')) return false;
    return p.basename(name) == name;
  }

  Future<void> _createFolder() async {
    final current = _currentDir;
    if (current == null) return;

    final folderName = await showDialog<String>(
      context: context,
      builder: (context) => const _NamePromptDialog(
        title: 'Create folder',
        labelText: 'Folder name',
        hintText: 'e.g. notes',
        actionText: 'Create',
      ),
    );

    final name = folderName?.trim();
    if (name == null || name.isEmpty) return;
    if (!_isValidSingleName(name)) {
      _showSnack('Invalid folder name');
      return;
    }

    final newDir = Directory(p.join(current.path, name));
    if (await newDir.exists()) {
      _showSnack('Folder already exists');
      return;
    }

    await newDir.create(recursive: true);
    await _refresh();
  }

  Future<void> _createTextFile() async {
    final current = _currentDir;
    if (current == null) return;

    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FileEditPage.create(directory: current),
      ),
    );
    if (saved == true) {
      await _refresh();
    }
  }

  Future<void> _editFile(File file) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FileEditPage.edit(file: file)),
    );
    if (saved == true) {
      await _refresh();
    }
  }

  Future<void> _openEntity(FileSystemEntity entity) async {
    if (entity is Directory) {
      setState(() => _currentDir = entity);
      await _refresh();
      return;
    }
    if (entity is File) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FileViewPage(file: entity)),
      );
      return;
    }
  }

  Future<void> _renameEntity(FileSystemEntity entity) async {
    final currentName = p.basename(entity.path);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => _NamePromptDialog(
        title: 'Rename',
        labelText: 'New name',
        initialValue: currentName,
        actionText: 'Rename',
      ),
    );

    final name = newName?.trim();
    if (name == null || name.isEmpty || name == currentName) return;
    if (!_isValidSingleName(name)) {
      _showSnack('Invalid name');
      return;
    }

    final targetPath = p.join(p.dirname(entity.path), name);
    final alreadyExists =
        await FileSystemEntity.type(targetPath) !=
        FileSystemEntityType.notFound;
    if (alreadyExists) {
      _showSnack('Name already exists');
      return;
    }

    await entity.rename(targetPath);
    await _refresh();
  }

  Future<void> _deleteEntity(FileSystemEntity entity) async {
    final name = p.basename(entity.path);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: Text('Delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await entity.delete(recursive: true);
      await _refresh();
    } catch (e) {
      _showSnack('Delete failed: $e');
    }
  }

  Future<void> _onEntityAction(
    FileSystemEntity entity,
    _EntityAction action,
  ) async {
    switch (action) {
      case _EntityAction.edit:
        if (entity is File) await _editFile(entity);
        return;
      case _EntityAction.rename:
        await _renameEntity(entity);
        return;
      case _EntityAction.delete:
        await _deleteEntity(entity);
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentDir;
    final title = current == null ? 'File Explorer' : 'Lesson Files';
    final themeController = ThemeScope.maybeOf(context);
    final selectedThemeMode = themeController?.themeMode;
    final isDarkEffective = Theme.of(context).brightness == Brightness.dark;
    final isLightSelected =
        selectedThemeMode == ThemeMode.light ||
        (!isDarkEffective && selectedThemeMode == null);
    final isDarkSelected =
        selectedThemeMode == ThemeMode.dark ||
        (isDarkEffective && selectedThemeMode == null);
    final query = _query.trim().toLowerCase();
    final visibleItems = query.isEmpty
        ? _items
        : _items.where((e) => e.name.toLowerCase().contains(query)).toList();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Create folder',
            onPressed: _currentDir == null ? null : _createFolder,
            icon: const Icon(Icons.create_new_folder_outlined),
          ),
          IconButton(
            tooltip: 'New file',
            onPressed: _currentDir == null ? null : _createTextFile,
            icon: const Icon(Icons.note_add_outlined),
          ),
          PopupMenuButton<_AppMenuAction>(
            tooltip: 'Menu',
            onSelected: (action) async {
              switch (action) {
                case _AppMenuAction.refresh:
                  await _refresh();
                  return;
                case _AppMenuAction.lightTheme:
                  await themeController?.setThemeMode(ThemeMode.light);
                  return;
                case _AppMenuAction.darkTheme:
                  await themeController?.setThemeMode(ThemeMode.dark);
                  return;
              }
            },
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: _AppMenuAction.lightTheme,
                checked: isLightSelected,
                child: const _MenuRow(
                  icon: Icons.light_mode_outlined,
                  text: 'Light theme',
                ),
              ),
              CheckedPopupMenuItem(
                value: _AppMenuAction.darkTheme,
                checked: isDarkSelected,
                child: const _MenuRow(
                  icon: Icons.dark_mode_outlined,
                  text: 'Dark theme',
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: _AppMenuAction.refresh,
                child: _MenuRow(icon: Icons.refresh, text: 'Refresh'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          child: IconButton(
                            tooltip: 'Up',
                            onPressed: _canGoUp ? _goUp : null,
                            icon: const Icon(Icons.arrow_upward_rounded, size: 20),
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                current == null ? '' : _relativePath(current),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                'Current Directory',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SearchBar(
                      controller: _searchController,
                      hintText: 'Search files and folders...',
                      leading: Icon(
                        Icons.search_rounded,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                      onChanged: (value) => setState(() => _query = value),
                      trailing: [
                        if (_query.trim().isNotEmpty)
                          IconButton(
                            tooltip: 'Clear',
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            icon: const Icon(Icons.close_rounded, size: 20),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline, size: 36),
                              const SizedBox(height: 12),
                              Text(
                                'Something went wrong',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Error: $_error',
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              FilledButton.icon(
                                onPressed: _refresh,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else if (visibleItems.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _query.trim().isEmpty
                                    ? Icons.folder_open_outlined
                                    : Icons.search_off_outlined,
                                size: 44,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _query.trim().isEmpty
                                    ? 'This folder is empty'
                                    : 'No results for "$_query"',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _query.trim().isEmpty
                                    ? 'Create a folder or a new file using the buttons in the top bar.'
                                    : 'Try a different keyword.',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                sliver: SliverList.separated(
                  itemCount: visibleItems.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = visibleItems[index];
                    final entity = item.entity;
                    final isDir = item.isDir;

                    final subtitleParts = <String>[];
                    if (!isDir && item.sizeBytes != null) {
                      subtitleParts.add(_formatBytes(item.sizeBytes!));
                    }
                    final modified = _formatModified(item.modified, context);
                    if (modified.isNotEmpty) subtitleParts.add(modified);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                        ),
                      ),
                      child: ListTile(
                        onTap: () => _openEntity(entity),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isDir
                                ? colorScheme.primary.withValues(alpha: 0.08)
                                : colorScheme.secondary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            isDir
                                ? Icons.folder_rounded
                                : Icons.insert_drive_file_rounded,
                            size: 24,
                            color: isDir
                                ? colorScheme.primary
                                : colorScheme.secondary,
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: subtitleParts.isEmpty
                            ? null
                            : Text(
                                subtitleParts.join('  •  '),
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                ),
                              ),
                        trailing: PopupMenuButton<_EntityAction>(
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                            size: 20,
                          ),
                          onSelected: (action) => _onEntityAction(entity, action),
                          itemBuilder: (context) => [
                            if (entity is File)
                              const PopupMenuItem(
                                value: _EntityAction.edit,
                                child: _MenuRow(
                                  icon: Icons.edit_rounded,
                                  text: 'Edit',
                                ),
                              ),
                            const PopupMenuItem(
                              value: _EntityAction.rename,
                              child: _MenuRow(
                                icon: Icons.drive_file_rename_outline_rounded,
                                text: 'Rename',
                              ),
                            ),
                            const PopupMenuItem(
                              value: _EntityAction.delete,
                              child: _MenuRow(
                                icon: Icons.delete_outline_rounded,
                                text: 'Delete',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EntryItem {
  final FileSystemEntity entity;
  final String name;
  final bool isDir;
  final DateTime? modified;
  final int? sizeBytes;

  const _EntryItem({
    required this.entity,
    required this.name,
    required this.isDir,
    required this.modified,
    required this.sizeBytes,
  });
}

enum _EntityAction { edit, rename, delete }

enum _AppMenuAction { refresh, lightTheme, darkTheme }

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MenuRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(icon, size: 20), const SizedBox(width: 12), Text(text)],
    );
  }
}

class _NamePromptDialog extends StatefulWidget {
  final String title;
  final String labelText;
  final String? hintText;
  final String initialValue;
  final String actionText;

  const _NamePromptDialog({
    required this.title,
    required this.labelText,
    this.hintText,
    this.initialValue = '',
    required this.actionText,
  });

  @override
  State<_NamePromptDialog> createState() => _NamePromptDialogState();
}

class _NamePromptDialogState extends State<_NamePromptDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
        ),
        onSubmitted: (value) => Navigator.pop(context, value.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: Text(widget.actionText),
        ),
      ],
    );
  }
}
