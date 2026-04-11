

import 'package:book_library_database/data/Book_model.dart';
import 'package:flutter/material.dart';

import '../data/library_db_service.dart';

class BookProvider extends ChangeNotifier{
  final LibraryDbService _dbService = LibraryDbService();
  void getAllBook()async{
    List<BookModel> books = await _dbService.getAllBook();
    print("book response $books");
  }
}

