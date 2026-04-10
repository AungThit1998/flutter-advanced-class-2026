import 'dart:io';
import 'dart:typed_data';

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
    _database = await openDatabase(dbPath, version: 1);
    _createAuthorTable();
  }

  //authors
  // id , name , description, photo
  static Future<void> _createAuthorTable() async {
    return _database.execute(
      "create table if not exists $_authorTable (id integer primary key autoincrement, name text, description text, photo blob, fav integer);",
    );
  }

   Future<int> insertAuthor({
    required String name,
    required String description,
    Uint8List? photo,
  }) {
    return _database.rawInsert(
      'insert into authors (name,description,photo,fav) values (?,?,?,?)',
      [name, description, photo,null],
    );
  }
  Future<List<AuthorModel>> getAllAuthor() async{
    final listOfMap = await _database.rawQuery("select * from $_authorTable");
    return listOfMap.map((json){
      return AuthorModel.fromJson(json);
    }).toList();
  }
  Future<int> getFavourite(int id) async{
    final favMap = await _database.rawQuery("select fav from authors where id = $id");
    if(favMap.isNotEmpty){
      return (favMap.first['fav'] as int?) ?? 0;
    }
    return 0;
  }
  Future<int> updateFavourite(int id,int isFav) async{
    return _database.rawUpdate("update authors set fav = $isFav where id = $id");
  }
}
