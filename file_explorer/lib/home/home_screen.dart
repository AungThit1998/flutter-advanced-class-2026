import 'dart:io';


import 'package:file_explorer/home/text_edit_screen.dart';
import 'package:flutter/material.dart';

import '../file_services/file_services.dart';
import 'create_new_file_dialog.dart';
import 'create_new_folder_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
                        _currentLocation = directory.join("/");
                        _loadFileAndFolder(_currentLocation);
                      },
                icon: Icon(Icons.arrow_back_ios),
              ),
              title: Text(_currentLocation.isEmpty ? "/" : _currentLocation),
            ),
          ),
          SliverList.builder(
            itemCount: _currentFolderList.length,
            itemBuilder: (context, index) {
              Directory directory = _currentFolderList[index];
              String folderName = directory.path.split("/").last;
              return ListTile(
                onTap: () {
                  String folderLocation = "$_currentLocation/$folderName";
                  _currentLocation = folderLocation;
                  _loadFileAndFolder(folderLocation);
                },
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
        return CreateNewFolderDialog(currentLocation: "$_currentLocation/");
      },
    );
    print(isOK);
    if (isOK) {
      _loadFileAndFolder(_currentLocation);
    }
  }

  void _createNewFile(String path) async {
    bool isOK = await showDialog(
      context: context,
      builder: (context) {
        return CreateNewFileDialog(currentLocation: '$_currentLocation/');
      },
    );
    if (isOK) {
      _loadFileAndFolder(_currentLocation);
    }
  }
}
