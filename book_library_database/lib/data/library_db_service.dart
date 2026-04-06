import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
class LibraryDbService {
  static final String _dbName = "library.db";
  static final String _bookTable = "books";
  static final String _authorTable = "authors";

 static late Database _database;
  static Future<void> createDatabase() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String dbPath = "${documentDirectory.path}/$_dbName";
     _database = await openDatabase(
      dbPath,
      version: 1,
    );
  }
}