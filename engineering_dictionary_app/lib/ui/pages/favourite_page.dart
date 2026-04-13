import 'package:engineering_dictionary_app/providers/favourite_provider.dart';
import 'package:engineering_dictionary_app/ui/widget/dictionary_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavouriteProvider>(context, listen: false).getFavouriteList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Favourites")),
      child: SafeArea(
        child: Consumer<FavouriteProvider>(
          builder: (context, provider, child) {
            return DictionaryListWidget(results: provider.favourites);
          },
        ),
      ),
    );
  }
}
