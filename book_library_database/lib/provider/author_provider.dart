import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../data/library_db_service.dart';

class AuthorProvider extends ChangeNotifier{
  final LibraryDbService _dbService = LibraryDbService();
  List<Map<String,dynamic>> authors = [];


  void getAllAuthor() async{
    authors = await _dbService.getAllAuthor();
    notifyListeners();
  }

  Future<int> saveAuthor({
    required String name,
    required String description,
    Uint8List? photo,
  }) async{
   final int count  = await _dbService.insertAuthor(name: name, description: description, photo: photo);
   getAllAuthor();
   return count;
  }
}
