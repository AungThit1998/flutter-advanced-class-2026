import 'dart:io';

import 'package:file_expolerer/file_services/file_services.dart';
import 'package:file_expolerer/home/create_new_file_dialog.dart';
import 'package:file_expolerer/home/create_new_folder_dialog.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FileServices _fileServices = FileServices();
  List<Directory> _currentFolderList = [];
  List<File> _currentFileList = [];

  @override
  void initState() {
    super.initState();
    _loadFileAndFolder("");
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
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemCount: _currentFolderList.length,
            itemBuilder: (context, index) {
              Directory directory = _currentFolderList[index];
              return ListTile(
                leading: Icon(Icons.folder),
                title: Text(directory.path.split('/').last),
                subtitle: Text(directory.statSync().changed.toString()),
              );
            },
          ),
          SliverList.builder(
            itemCount: _currentFileList.length,
            itemBuilder: (context, index) {
              File file = _currentFileList[index];
              return ListTile(
                leading: Icon(Icons.file_copy_outlined),
                title: Text(file.path.split("/").last),
                subtitle: Text(file.statSync().changed.toString()),
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

  void _createNewFolder(String path) async {
    bool isOK = await showDialog(
      context: context,
      builder: (context) {
        return CreateNewFolderDialog();
      },
    );
    print(isOK);
    if (isOK) {
      _loadFileAndFolder("");
    }
  }

  void _createNewFile(String path) async {
    bool isOK = await showDialog(
      context: context,
      builder: (context) {
        return CreateNewFileDialog();
      },
    );
    if (isOK) {
      _loadFileAndFolder("");
    }
  }
}
