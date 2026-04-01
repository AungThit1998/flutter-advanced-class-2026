import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class FileEditPage extends StatefulWidget {
  final Directory directory;
  final File? existingFile;
  final String? initialFileName;

  const FileEditPage.create({
    super.key,
    required this.directory,
    this.initialFileName,
  }) : existingFile = null;

  FileEditPage.edit({super.key, required File file})
    : existingFile = file,
      directory = file.parent,
      initialFileName = null;

  bool get isEdit => existingFile != null;

  @override
  State<FileEditPage> createState() => _FileEditPageState();

  static String defaultFileName() {
    final now = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    final stamp =
        '${now.year}${two(now.month)}${two(now.day)}_${two(now.hour)}${two(now.minute)}${two(now.second)}';
    return 'note_$stamp.txt';
  }
}

class _FileEditPageState extends State<FileEditPage> {
  late final TextEditingController _contentController;
  late final TextEditingController _fileNameController;

  String _initialContent = '';
  late final String _initialFileName;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _fileNameController = TextEditingController(
      text: widget.initialFileName ?? FileEditPage.defaultFileName(),
    );
    _initialFileName = _fileNameController.text;
    _loadIfEditing();
    _contentController.addListener(_onChanged);
    _fileNameController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _contentController.removeListener(_onChanged);
    _fileNameController.removeListener(_onChanged);
    _contentController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  void _onChanged() {
    setState(() {});
  }

  bool get _hasUnsavedChanges {
    if (widget.isEdit) {
      return _contentController.text != _initialContent;
    }
    final normalized = _normalizeNewFileName(_fileNameController.text);
    return _contentController.text.trim().isNotEmpty ||
        normalized != _normalizeNewFileName(_initialFileName);
  }

  Future<void> _loadIfEditing() async {
    final file = widget.existingFile;
    if (file == null) return;

    setState(() => _loading = true);
    try {
      final content = await file.readAsString();
      if (!mounted) return;
      _initialContent = content;
      _contentController.text = content;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cannot read file: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _isValidSingleName(String name) {
    if (name.trim().isEmpty) return false;
    if (name == '.' || name == '..') return false;
    if (name.contains('/') || name.contains('\\')) return false;
    return p.basename(name) == name;
  }

  String _normalizeNewFileName(String input) {
    var fileName = input.trim();
    if (!fileName.contains('.')) fileName = '$fileName.txt';
    return fileName;
  }

  Future<bool> _confirmDiscardChanges() async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved changes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return discard == true;
  }

  Future<void> _save() async {
    if (_loading) return;

    final content = _contentController.text;
    if (content.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Type something first')));
      return;
    }

    if (widget.isEdit) {
      final file = widget.existingFile!;
      await file.writeAsString(content);
      if (!mounted) return;
      Navigator.pop(context, true);
      return;
    }

    var fileName = _normalizeNewFileName(_fileNameController.text);
    if (!_isValidSingleName(fileName)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid file name')));
      return;
    }

    final file = File(p.join(widget.directory.path, fileName));
    if (await file.exists()) {
      if (!mounted) return;
      final overwrite = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('File exists'),
          content: Text('Overwrite "$fileName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Overwrite'),
            ),
          ],
        ),
      );
      if (overwrite != true) return;
    }

    await file.writeAsString(content);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEdit
        ? p.basename(widget.existingFile!.path)
        : 'New File';
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (!_hasUnsavedChanges) {
          Navigator.of(this.context).pop();
          return;
        }
        final discard = await _confirmDiscardChanges();
        if (!mounted) return;
        if (discard) Navigator.of(this.context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton.filledTonal(
                tooltip: 'Save',
                onPressed: _loading ? null : _save,
                icon: const Icon(Icons.check_rounded, size: 20),
              ),
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    children: [
                      if (!widget.isEdit) ...[
                        TextField(
                          controller: _fileNameController,
                          decoration: const InputDecoration(
                            labelText: 'File name',
                            hintText: 'e.g. my_note.txt',
                            prefixIcon: Icon(Icons.description_outlined, size: 20),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                      ],
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: TextField(
                              controller: _contentController,
                              maxLines: null,
                              expands: true,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 14,
                                height: 1.5,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Start typing your note...',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.all(20),
                                fillColor: Colors.transparent,
                                filled: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: _loading ? null : _save,
                          icon: const Icon(Icons.save_rounded, size: 20),
                          label: const Text('Save File'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      );
  }
}
