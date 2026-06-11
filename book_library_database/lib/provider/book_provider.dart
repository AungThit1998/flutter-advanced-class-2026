import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../data/library_db_service.dart';
import 'package:book_library_database/data/book_model.dart';

class BookProvider extends ChangeNotifier {
  final LibraryDbService _dbService = LibraryDbService();
  int isDetailFav = 0;
  List<BookModel> books = [];

  void getAllBook() async {
    books = await _dbService.getAllBooks();
    notifyListeners();
  }

  void getAllFavBook() async {
    books = await _dbService.getAllFavBooks();
    notifyListeners();
  }

  Future<int> saveBook({
    required String name,
    required String description,
    Uint8List? cover,
    int authorId = 1,
    required String reference,
  }) async {
    final int count = await _dbService.insertBook(
      name: name,
      description: description,
      cover: cover,
      authorId: 1,
      reference: reference,
    );
    getAllBook();
    return count;
  }

  Future<int> updateFavourite(int id, int isFav) async {
    final result = await _dbService.updateFavourite(id, isFav);
    getFavourite(id);
    return result;
  }

  Future<int> getFavourite(int id) async {
    isDetailFav = await _dbService.getFavourite(id);
    notifyListeners();
    return isDetailFav;
  }

  Future<int> deleteBook(int id) async {
    int result = await _dbService.deleteBook(id);
    getAllBook();
    return result;
  }

  Future<int> updateBook({
    int id = 1,
    String title = "",
    String description = "",
    int authorId = 1,
    String reference = "",
  }) async {
    int result = await _dbService.updateBook(
      id: id,
      title: title,
      description: description,
      authorId: authorId,
      reference: reference,
    );
    getAllBook();
    return result;
  }
}
