import 'dart:io';
import 'dart:typed_data';

import 'package:book_library_database/data/book_model.dart';
import 'package:book_library_database/data/aithor_model.dart';
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
    _database = await openDatabase(
      dbPath,
      version: 1,
      onConfigure: (db) {
        db.execute("PRAGMA foreign_keys = ON;");
      },
    );
    _createAuthorTable();
    _createBookTable();
  }

  //authors
  // id , name , description, photo
  static Future<void> _createAuthorTable() async {
    return _database.execute(
      "create table if not exists $_authorTable (id integer primary key autoincrement, name text, description text, photo blob, fav integer);",
    );
  }

  static Future<void> _createBookTable() async {
    await _database.execute('''
         CREATE TABLE IF NOT EXISTS $_bookTable (
               id INTEGER PRIMARY KEY AUTOINCREMENT,
               title TEXT NOT NULL,
               description TEXT,
               cover BLOB,
                fav INTEGER,
               author_id INTEGER NOT NULL,
               FOREIGN KEY(author_id) REFERENCES authors(id) ON DELETE RESTRICT  
             );
      ''');
  }

  Future<int> insertAuthor({
    required String name,
    required String description,
    Uint8List? photo,
  }) {
    return _database.rawInsert(
      'insert into authors (name,description,photo,fav) values (?,?,?,?)',
      [name, description, photo, null],
    );
  }

  Future<int> insertBook({
    required String name,
    required String description,
    Uint8List? cover,
    required int authorId,
  }) {
    return _database.rawInsert(
      'INSERT INTO $_bookTable (title, description, cover,fav, author_id) VALUES (?,?,?,?,?);',
      [name, description, cover, null, authorId],
    );
  }

  Future<List<AuthorModel>> getAllAuthor() async {
    final listOfMap = await _database.rawQuery("select * from $_authorTable");
    return listOfMap.map((json) {
      return AuthorModel.fromJson(json);
    }).toList();
  }

  Future<List<AuthorModel>> getAllFavAuthor() async {
    final listOfMap = await _database.rawQuery(
      "select * from $_authorTable where fav = 1",
    );
    return listOfMap.map((json) {
      return AuthorModel.fromJson(json);
    }).toList();
  }

  Future<List<BookModel>> getAllBooks() async {
    final listOfMap = await _database.rawQuery(
      'SELECT b.*, a.name FROM books b JOIN authors a ON a.id = b.author_id;',
    );
    return listOfMap.map((json) {
      return BookModel.fromJson(json);
    }).toList();
  }

  Future<List<BookModel>> getAllFavBooks() async {
    final listOfMap = await _database.rawQuery(
      'SELECT b.*, a.name FROM books b JOIN authors a ON a.id = b.author_id where fav = 1;',
    );
    return listOfMap.map((json) {
      return BookModel.fromJson(json);
    }).toList();
  }

  Future<int> getFavourite(int id) async {
    final favMap = await _database.rawQuery(
      "select fav from $_authorTable where id = $id",
    );
    if (favMap.isNotEmpty) {
      return (favMap.first['fav'] as int?) ?? 0;
    }
    return 0;
  }

  Future<int> updateFavourite(int id, int isFav) async {
    return _database.rawUpdate(
      "update $_authorTable set fav = $isFav where id = $id",
    );
  }

  Future<int> deleteAuthor(int id) {
    return _database.rawDelete("delete from $_authorTable where id = $id");
  }

  Future<int> deleteBook(int id) {
    return _database.rawDelete("delete from $_bookTable where id = $id");
  }

  Future<int> updateAuthor({
    required int id,
    required String name,
    required String description,
  }) {
    return _database.update(
      _authorTable,
      {"name": name, "description": description},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateBook({
    required int id,
    required String name,
    required String description,
  }) {
    return _database.update(
      _bookTable,
      {"name": name, "description": description},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
