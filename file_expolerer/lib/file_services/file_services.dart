import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileServices {
  //folder => Directory
  //file => File
  // document/folder1/myFolder/music
  Future<Directory> getRootDirectory() {
    return getApplicationDocumentsDirectory();
  }

  Future<Directory> createFolder(String folderName) async {
    Directory root = await getRootDirectory();
    Directory myFolder = Directory("${root.path}/$folderName");
    bool isExist = await myFolder.exists();
    if (!isExist) {
      await myFolder.create(recursive: true);
    }
    return myFolder;
  }

  Future<File> writeFile(String fileName,String content) async {
    Directory root = await getRootDirectory();
    File file = File('${root.path}/$fileName');
    bool isExist = await file.exists();
    if (!isExist) {
      await file.create(recursive: true);
    }
    await file.writeAsString(content);
    return file;
  }
}
