import 'dart:io';
import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class LibraryDbService {
  static final String _dbName = "library.db";
  static final String _bookTable = "books";
  static final String _authorTable = "authors";

  static late Database _database;

  static Future<void> createDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String dbPath = "${documentDirectory.path}/$_dbName";
    _database = await openDatabase(dbPath, version: 1);
    _createAuthorTable();
    _insertAuthor(name: "Leo T S", description: "War and Peace Author");
  }

  //authors
  // id , name , description, photo
  static Future<void> _createAuthorTable() async {
    return _database.execute(
      "create table if not exists $_authorTable (id integer primary key autoincrement, name text, description text, photo blob);",
    );
  }

  static Future<int> _insertAuthor({
    required String name,
    required String description,
    Uint8List? photo,
  }) {
    return _database.rawInsert(
      'insert into authors (name,description,photo) values (?,?,?)',
      [name, description, photo],
    );
  }
}
