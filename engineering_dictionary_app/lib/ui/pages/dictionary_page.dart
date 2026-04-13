import 'package:engineering_dictionary_app/database/database_model.dart';
import 'package:engineering_dictionary_app/providers/engineering_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../widget/dictionary_list_widget.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (_, _) {
          return [
            CupertinoSliverNavigationBar(
              largeTitle: Text("Engineering Dictionary"),
            ),
          ];
        },
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                placeholder: "Search English word",
                onChanged: (String text) {
                  Provider.of<EngineeringProvider>(
                    context,
                    listen: false,
                  ).search(text);
                },
              ),
            ),
            Expanded(
              child: Consumer<EngineeringProvider>(
                builder: (_, provider, _) {
                  List<DatabaseModel> results = provider.results;
                  if (results.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.doc_text_search),
                          SizedBox(height: 16),
                          Text("Search Keyword"),
                        ],
                      ),
                    );
                  }
                  return DictionaryListWidget(results: results);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
