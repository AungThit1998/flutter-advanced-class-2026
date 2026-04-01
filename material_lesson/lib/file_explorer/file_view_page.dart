import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'file_edit_page.dart';

class FileViewPage extends StatefulWidget {
  final File file;

  const FileViewPage({super.key, required this.file});

  @override
  State<FileViewPage> createState() => _FileViewPageState();
}

class _FileViewPageState extends State<FileViewPage> {
  late Future<String> _contentFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _contentFuture = widget.file.readAsString();
  }

  Future<void> _edit() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FileEditPage.edit(file: widget.file)),
    );
    if (saved == true) {
      setState(_reload);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = p.basename(widget.file.path);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filledTonal(
              tooltip: 'Edit',
              onPressed: _edit,
              icon: const Icon(Icons.edit_rounded, size: 20),
            ),
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: _contentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      'Cannot read file',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          }
          final content = snapshot.data ?? '';
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: SelectableText(
                    content,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
