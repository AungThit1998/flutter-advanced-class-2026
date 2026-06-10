import 'dart:io';

import 'package:file_explorer/home/delete_confirm_dialog.dart';
import 'package:file_explorer/home/text_edit_screen.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import '../file_services/file_services.dart';
import 'create_or_rename_folder_dialog.dart';
import 'create_or_rename_file_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FileServices _fileServices = FileServices();
  List<Directory> _currentFolderList = [];
  List<File> _currentFileList = [];
  String _currentLocation = "";

  @override
  void initState() {
    super.initState();
    _loadFileAndFolder(_currentLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File Explorer"),
        actions: [
          IconButton(
            tooltip: 'Creat new Folder',
            onPressed: () async {
              _createNewFolder("");
            },
            icon: Icon(Icons.create_new_folder),
          ),
          IconButton(
            tooltip: 'Create new File',
            onPressed: () async {
              _createNewFile("");
            },
            icon: Icon(Icons.note_add_outlined),
          ),
          PopupMenuButton<ThemeMode>(
            initialValue: widget.themeMode,
            onSelected: widget.onThemeChanged,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: ThemeMode.light,
                  child: Text("Light Theme"),
                ),
                PopupMenuItem(value: ThemeMode.dark, child: Text("Dark Theme")),
                PopupMenuItem(value: ThemeMode.system, child: Text("System")),
              ];
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ListTile(
              leading: IconButton(
                onPressed: _currentLocation == ""
                    ? null
                    : () {
                        List<String> directory = _currentLocation.split("/");
                        directory.removeLast();
                        _openFolder(directory.join("/"));
                      },
                icon: Icon(Icons.arrow_back_ios),
              ),
              title: _PathWidget(
                currentLocation: _currentLocation,
                onPathSelected: _openFolder,
              ),
            ),
          ),
          SliverList.builder(
            itemCount: _currentFolderList.length,
            itemBuilder: (context, index) {
              Directory directory = _currentFolderList[index];
              String folderName = directory.path.split("/").last;
              String folderLocation = "$_currentLocation/$folderName";
              return ListTile(
                onTap: () {
                  _openFolder(folderLocation);
                },
                leading: Icon(Icons.folder),
                title: Text(directory.path.split('/').last),
                subtitle: Text(directory.statSync().changed.toString()),
                trailing: PopupMenuButton<String>(
                  onSelected: (String str) async {
                    if (str == 'delete') {
                      bool isDelete = await showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteConfirmDialog(
                            title: "Delete Folder",
                            content: "Are you sure to delete $folderName",
                          );
                        },
                      );
                      if (isDelete && context.mounted) {
                        _deleteFolder(
                          folderLocation: folderLocation,
                          folderName: folderName,
                          context: context,
                        );
                      }
                    } else if (str == 'rename') {
                      _renameFolder("", folderName);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<String>(
                        value: "rename",
                        child: Text("Rename"),
                      ),
                      PopupMenuItem<String>(
                        value: "delete",
                        child: Text("Delete"),
                      ),
                    ];
                  },
                ),
              );
            },
          ),
          SliverList.builder(
            itemCount: _currentFileList.length,
            itemBuilder: (context, index) {
              File file = _currentFileList[index];
              String fileName = file.path.split("/").last;
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TextEditScreen(
                          currentFileLocation: '$_currentLocation/$fileName',
                        );
                      },
                    ),
                  );
                },
                leading: Icon(Icons.file_copy_outlined),
                title: Text(fileName),
                subtitle: Text(file.statSync().changed.toString()),
                trailing: PopupMenuButton<String>(
                  onSelected: (String str) async {
                    if (str == 'export') {
                      FileSaver.instance.saveAs(
                        name: fileName,
                        bytes: file.readAsBytesSync(),
                        fileExtension: 'txt',
                        mimeType: MimeType.text,
                      );
                    } else if (str == 'delete') {
                      bool isDelete = await showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteConfirmDialog(
                            title: "Delete File",
                            content: "Are you sure to delete $fileName",
                          );
                        },
                      );
                      if (isDelete && context.mounted) {
                        _deleteFile(
                          fileLocation: '$_currentLocation/$fileName',
                          fileName: fileName,
                          context: context,
                        );
                      }
                    } else if (str == 'rename') {
                      bool isOK = await showDialog(
                        context: context,
                        builder: (context) {
                          return CreateOrRenameFileDialog(
                            currentLocation: "$_currentLocation/",
                            oldName: fileName,
                          );
                        },
                      );

                      if (isOK) {
                        _loadFileAndFolder(_currentLocation);
                      }
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<String>(
                        value: "rename",
                        child: Text("Rename"),
                      ),
                      PopupMenuItem<String>(
                        value: "delete",
                        child: Text("Delete"),
                      ),
                      PopupMenuItem<String>(
                        value: "export",
                        child: Text("Export"),
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _loadFileAndFolder(String path) async {
    _currentFolderList = await _fileServices.getFolderList(path);
    _currentFileList = await _fileServices.getFileList(path);
    setState(() {});
  }

  void _openFolder(String path) {
    _currentLocation = path;
    _loadFileAndFolder(path);
  }

  void _createNewFolder(String path) async {
    bool isOK = await showDialog(
      context: context,
      builder: (context) {
        return CreateOrRenameFolderDialog(
          currentLocation: "$_currentLocation/",
        );
      },
    );
    if (isOK) {
      _loadFileAndFolder(_currentLocation);
    }
  }

  void _renameFolder(String path, String oldName) async {
    bool isOK = await showDialog(
      context: context,
      builder: (context) {
        return CreateOrRenameFolderDialog(
          currentLocation: "$_currentLocation/",
          oldName: oldName,
        );
      },
    );
    if (isOK) {
      _loadFileAndFolder(_currentLocation);
    }
  }

  void _createNewFile(String path) async {
    bool isOK = await showDialog(
      context: context,
      builder: (context) {
        return CreateOrRenameFileDialog(currentLocation: '$_currentLocation/');
      },
    );
    if (isOK) {
      _loadFileAndFolder(_currentLocation);
    }
  }

  void _deleteFolder({
    required String folderLocation,
    required String folderName,
    required BuildContext context,
  }) async {
    try {
      await _fileServices.deleteFolder(folderLocation);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("Delete success $folderName"),
          ),
        );
      }
      _loadFileAndFolder(_currentLocation);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Delete Failed $folderName"),
          ),
        );
      }
    }
  }

  void _deleteFile({
    required String fileLocation,
    required String fileName,
    required BuildContext context,
  }) async {
    try {
      await _fileServices.deleteFile(fileLocation);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("Delete success $fileName"),
          ),
        );
      }
      _loadFileAndFolder(_currentLocation);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Delete Failed $fileName"),
          ),
        );
      }
    }
  }
}

class _PathWidget extends StatelessWidget {
  const _PathWidget({
    required this.currentLocation,
    required this.onPathSelected,
  });

  final String currentLocation;
  final ValueChanged<String> onPathSelected;

  @override
  Widget build(BuildContext context) {
    final pathParts = currentLocation
        .split("/")
        .where((part) => part.isNotEmpty)
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _PathSegment(
            label: "/",
            onTap: currentLocation.isEmpty ? null : () => onPathSelected(""),
          ),
          for (int index = 0; index < pathParts.length; index++) ...[
            const Icon(Icons.chevron_right, size: 18),
            _PathSegment(
              label: pathParts[index],
              onTap: () {
                final selectedPath = pathParts.take(index + 1).join("/");
                onPathSelected(selectedPath);
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _PathSegment extends StatelessWidget {
  const _PathSegment({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label),
    );
  }
}
