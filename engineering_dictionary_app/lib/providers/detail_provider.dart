import 'package:flutter/cupertino.dart';

import '../database/db_service.dart';

class DetailProvider extends ChangeNotifier {
  final DbService _dbService = DbService();
  int? favourite;

  void getFavourite(int id) async {
    favourite = await _dbService.getFavourite(id);
    notifyListeners();
  }

  void updateFavourite(int id, int favourite) async {
    await _dbService.updateFavourite(id, favourite);
    getFavourite(id);
  }
}
