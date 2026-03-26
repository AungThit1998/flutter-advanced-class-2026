import 'package:file_expolerer/file_services/file_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FileServices _fileServices = FileServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File Explorer"),
        actions: [
          IconButton(
            tooltip: 'Creat new Folder',
            onPressed: () async {
              await _fileServices.createFolder("test folder");
            },
            icon: Icon(Icons.create_new_folder),
          ),
          IconButton(
            tooltip: 'Create new File',
            onPressed: () async {
              await _fileServices.writeFile("test file", '');
            },
            icon: Icon(Icons.upload_file),
          ),
        ],
      ),
    );
  }
}
