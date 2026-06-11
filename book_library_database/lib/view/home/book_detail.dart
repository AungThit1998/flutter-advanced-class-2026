import 'dart:typed_data';
import 'package:book_library_database/const/theme/app_theme_token.dart';
import 'package:book_library_database/data/book_model.dart';
import 'package:book_library_database/provider/author_provider.dart';
import 'package:book_library_database/provider/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetail extends StatefulWidget {
  const BookDetail({super.key, required this.bookData});

  final BookModel bookData;

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).getFavourite(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppThemeTokens themeTokens = Theme.of(context).extension<AppThemeTokens>()!;
    BookModel book = widget.bookData;
    String id = "BOOK${book.id.toString()}";
    String name = book.title!;
    String description = book.description!;
    Uint8List? photo = book.cover;

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          photo != null
              ? Image.memory(
                  photo,
                  height: 350,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
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
                builder: (context, provider, child) {
                  bool isFav = provider.isDetailFav == 1;
                  return IconButton(
                    onPressed: () {
                      // provider.updateFavourite(
                      //   widget.bookData.id,
                      //   isFav ? 0 : 1,
                      // );
                    },
                    icon: isFav
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: -380,
            left: 30,
            right: 30,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 25,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: themeTokens.onBackground,
                      ),
                    ),
                    Text(
                      "Author: Dr.Alan Turing",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeTokens.primary,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: themeTokens.surface,
                            border: Border.all(
                              width: 1,
                              color: themeTokens.surface,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'ID: $id',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: themeTokens.onBackground,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      decoration: BoxDecoration(
                        color: themeTokens.surface,
                        border: Border.all(
                          width: 1,
                          color: themeTokens.surface,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: .spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 16,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '1',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: themeTokens.onBackground,
                                  ),
                                ),
                                Text(
                                  'VERSION',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: themeTokens.onBackground,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: .center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '342b',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: themeTokens.onBackground,
                                  ),
                                ),
                                Text(
                                  'SIZE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: themeTokens.onBackground,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: .center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'OK',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: themeTokens.onBackground,
                                  ),
                                ),
                                Text(
                                  'STATUS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: themeTokens.onBackground,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "Payload Output",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: themeTokens.onBackground,
                      ),
                    ),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: themeTokens.onBackground,
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
