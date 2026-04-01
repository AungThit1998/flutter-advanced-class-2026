import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileServices {
  //folder => Directory
  //file => File
  // document/folder1/myFolder/music
  Future<Directory> getRootDirectory() {
    return getApplicationDocumentsDirectory();
  }

  Future<Directory> createFolder(
    String folderName, {
    Function(String stauts)? status,
  }) async {
    Directory root = await getRootDirectory();
    Directory myFolder = Directory("${root.path}/$folderName");
    bool isExist = await myFolder.exists();
    if (!isExist) {
      await myFolder.create(recursive: true);
      status?.call("Successfully created");
    } else {
      status?.call("File already exist");
    }
    return myFolder;
  }

  Future<File> writeFile(
    String fileName,
    String content, {
    Function(String stauts)? status,
  }) async {
    Directory root = await getRootDirectory();
    File file = File('${root.path}/$fileName');
    bool isExist = await file.exists();
    if (!isExist) {
      await file.create(recursive: true);
      status?.call("Successfully created");
    } else {
      status?.call("File already exist");
    }
    await file.writeAsString(content);
    return file;
  }

  Future<List<Directory>> getFolderList(String path) async {
    Directory root = await getRootDirectory();
    Directory currentFolder = Directory("${root.path}/$path");
    final list = currentFolder.list();
    return list
        .where((entity) => entity is Directory)
        .cast<Directory>()
        .toList();
  }

  Future<List<File>> getFileList(String path) async {
    Directory root = await getRootDirectory();
    Directory currentFolder = Directory("${root.path}/$path");
    final list = currentFolder.list();
    return list.where((entity) => entity is File).cast<File>().toList();
  }

  Future<String> readFile(String fileLocation) async {
    Directory root = await getRootDirectory();
    File file = File('${root.path}/$fileLocation');
    return file.readAsString();
  }

  Future<void> deleteFile(String fileLocation) async {
    Directory root = await getRootDirectory();
    File file = File('${root.path}/$fileLocation');
    await file.delete();
  }

  Future<void> deleteFolder(String path) async {
    Directory root = await getRootDirectory();
    Directory currentFolder = Directory("${root.path}/$path");
    await currentFolder.delete(recursive: true);
  }

  Future<void> renameFile(String fileLocation, String newFileLocation) async {
    Directory root = await getRootDirectory();
    File file = File('${root.path}/$fileLocation');
    String newFilePath = '${root.path}/$newFileLocation';
    File newFile = File(newFilePath);
    if (newFile.existsSync()) {
      throw Exception("File already exists.Please choose difference name");
    }
    await file.rename(newFilePath);
  }

  Future<void> renameFolder(String path, String newPath) async {
    Directory root = await getRootDirectory();
    Directory currentFolder = Directory("${root.path}/$path");
    String newFolderPath = '${root.path}/$newPath';
    Directory newFolder = Directory(newFolderPath);
    if (newFolder.existsSync()) {
      throw Exception("Folder already exists.Please choose difference name");
    }
    await currentFolder.rename(newFolderPath);
  }
}
