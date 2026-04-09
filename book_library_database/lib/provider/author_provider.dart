import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../data/library_db_service.dart';

class AuthorProvider extends ChangeNotifier{
  final LibraryDbService _dbService = LibraryDbService();

  Future<int> saveAuthor({
    required String name,
    required String description,
    Uint8List? photo,
  }) {
   return _dbService.insertAuthor(name: name, description: description, photo: photo);
  }
}
