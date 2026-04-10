import 'dart:typed_data';

import 'package:book_library_database/data/aithor_model.dart';
import 'package:flutter/material.dart';

import '../data/library_db_service.dart';

class AuthorProvider extends ChangeNotifier{
  final LibraryDbService _dbService = LibraryDbService();
  int isDetailFav = 0;
  List<AuthorModel> authors = [];


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
  Future<int> updateFavourite(int id,int isFav) async{
    int result = await  _dbService.updateFavourite(id,isFav);
    await getFavourite(id);
    notifyListeners();
    return result;
  }
  Future<int> getFavourite(int id) async{
    isDetailFav =  await _dbService.getFavourite(id);
    notifyListeners();
    return isDetailFav;

  }
}
