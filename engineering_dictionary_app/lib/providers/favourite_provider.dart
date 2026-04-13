import 'package:flutter/material.dart';

import '../database/database_model.dart';
import '../database/db_service.dart';

class FavouriteProvider extends ChangeNotifier {
  List<DatabaseModel> favourites = [];
  final DbService _dbService = DbService();

  void getFavouriteList() async {
    favourites = [];
    favourites = await _dbService.getAllFavList();
    notifyListeners();
  }
}
