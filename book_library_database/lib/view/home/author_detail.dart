import 'dart:typed_data';

import 'package:book_library_database/const/theme/app_theme_token.dart';
import 'package:book_library_database/data/aithor_model.dart';
import 'package:book_library_database/provider/author_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorDetail extends StatefulWidget {
  const AuthorDetail({super.key, required this.authorData});

  final AuthorModel authorData;

  @override
  State<AuthorDetail> createState() => _AuthorDetailState();
}

class _AuthorDetailState extends State<AuthorDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<AuthorProvider>(context,listen: false).getFavourite(widget.authorData.id);
    });
  }
  @override
  Widget build(BuildContext context) {
    AppThemeTokens themeTokens = Theme.of(context).extension<AppThemeTokens>()!;
    AuthorProvider authorProvider = Provider.of(context,listen: false);
    AuthorModel author = widget.authorData;
    String name = author.name;
    String description = author.description;
    Uint8List? photo = author.photo;
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          photo != null
              ? Image.memory(photo, height: 350, fit: BoxFit.cover,width: double.infinity,)
              : Container(color: themeTokens.background, height: 350),
          Positioned(
            top: 50,
            left: 30,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: themeTokens.backBtnBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 30,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: themeTokens.backBtnBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Consumer<AuthorProvider>(
                builder: (context,provider,child) {
                  bool isFav = provider.isDetailFav == 1;
                  return IconButton(
                    onPressed: () {
                      int updatedValue = isFav ? 0 : 1;
                       authorProvider.updateFavourite(widget.authorData.id,updatedValue);
                    },
                    icon: isFav ?  Icon(Icons.favorite) : Icon(Icons.favorite_border),
                  );
                }
              ),
            ),
          ),
          Positioned(
            bottom: -350,
            left: 50,
            right: 50,
            height: 400,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 32,
                        color: themeTokens.onBackground,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: themeTokens.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
