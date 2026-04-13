import 'package:engineering_dictionary_app/database/database_model.dart';
import 'package:engineering_dictionary_app/providers/detail_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DictionaryDetailPage extends StatefulWidget {
  const DictionaryDetailPage({super.key, required this.databaseModel});

  final DatabaseModel databaseModel;

  @override
  State<DictionaryDetailPage> createState() => _DictionaryDetailPageState();
}

class _DictionaryDetailPageState extends State<DictionaryDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DetailProvider>(
        context,
        listen: false,
      ).getFavourite(widget.databaseModel.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseModel model = widget.databaseModel;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(model.eng),
        trailing: Consumer<DetailProvider>(
          builder: (context, provider, child) {
            int? fav = provider.favourite;
            return GestureDetector(
              onTap: () {
                int newFav = fav == 1 ? 0 : 1;
                Provider.of<DetailProvider>(
                  context,
                  listen: false,
                ).updateFavourite(model.id, newFav);
              },
              child: fav == 1
                  ? Icon(CupertinoIcons.heart_fill)
                  : Icon(CupertinoIcons.heart),
            );
          },
        ),
      ),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
            padding: EdgeInsets.all(12),
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
                Text("ENGLISH DEFINITION", style: TextStyle(fontSize: 11)),
                SizedBox(height: 8),
                Text(
                  model.eng,
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
              ),
              child: Text(model.type),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
            padding: EdgeInsets.all(12),
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
                Text("MYANMAR မြန်မာဘာသာ", style: TextStyle(fontSize: 11)),
                SizedBox(height: 8),
                Text(
                  model.myan.split("~~~")[0],
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
