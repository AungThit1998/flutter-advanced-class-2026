
import 'package:flutter/material.dart';

import '../data/library_db_service.dart';

class BookProvider extends ChangeNotifier{
  final LibraryDbService _dbService = LibraryDbService();
    void getAllBook() async{
      final books = await _dbService.getAllBooks();
      print(books);
    }
}