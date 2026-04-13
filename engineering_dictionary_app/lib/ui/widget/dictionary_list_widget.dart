import 'package:engineering_dictionary_app/ui/pages/dictionary_detail_page.dart';
import 'package:flutter/cupertino.dart';

import '../../database/database_model.dart';

class DictionaryListWidget extends StatelessWidget {
  const DictionaryListWidget({super.key, required this.results});

  final List<DatabaseModel> results;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: results.length,
      itemBuilder: (context, index) {
        DatabaseModel model = results[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) {
                  return DictionaryDetailPage(databaseModel: model,);
                },
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              border: Border.all(
                color: CupertinoColors.systemGrey5.resolveFrom(context),
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.eng,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  model.type,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  model.myan,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
