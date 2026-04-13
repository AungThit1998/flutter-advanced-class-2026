import 'dart:io';
import 'dart:typed_data';

import 'package:engineering_dictionary_app/database/database_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static late Database _database;
  final String _tableName = "engineers";

  static Future<void> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    File dbFile = File("${directory.path}/engineering.db");
    if (!dbFile.existsSync()) {
      ByteData byteData = await rootBundle.load("assets/engineering.db");
      ByteBuffer buffer = byteData.buffer;
      await dbFile.writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
    }
    _database = await openDatabase(dbFile.path);
  }

  Future<List<DatabaseModel>> search(String keyword, {int limit = 20}) async {
    final listOfMap = await _database.rawQuery(
      'select * from $_tableName where eng LIKE "$keyword%" limit $limit ',
    );
    return listOfMap.map((map) {
      return DatabaseModel.fromMap(map);
    }).toList();
  }

  Future<int?> getFavourite(int id) async {
    final listOfMap = await _database.rawQuery(
      "select favourite from $_tableName where id = $id",
    );
    return listOfMap.isNotEmpty ? listOfMap[0]['favourite'] as int? : null;
  }

  Future<int> updateFavourite(int id, int favourite) async {
    return _database.rawUpdate(
      "update $_tableName set favourite = $favourite where id = $id;",
    );
  }

  Future<List<DatabaseModel>> getAllFavList() async {
    final listOfMap = await _database.rawQuery(
      'select * from $_tableName where favourite = 1;',
    );
    return listOfMap.map((map) {
      return DatabaseModel.fromMap(map);
    }).toList();
  }

  Future<void> clearFavourite() async {
    await _database.rawQuery(
      "update engineers set favourite = 0 where favourite =  1;",
    );
  }
}
