import 'package:flutter/cupertino.dart';

import '../database/database_model.dart';
import '../database/db_service.dart';

class EngineeringProvider extends ChangeNotifier {
  List<DatabaseModel> results = [];
  final DbService _dbService = DbService();

  void search(String keyword) async {
    results = await _dbService.search(keyword);
    notifyListeners();
  }

  void clearAllFAv() async {
    await _dbService.clearFavourite();
  }
}
