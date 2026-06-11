import 'dart:typed_data';

import 'package:book_library_database/const/theme/app_theme_token.dart';
import 'package:book_library_database/data/book_model.dart';
import 'package:book_library_database/provider/book_provider.dart';
import 'package:book_library_database/view/home/book_detail.dart';
import 'package:book_library_database/view/home/widgets/add_book_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).getAllBook();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppThemeTokens themeTokens = Theme.of(context).extension<AppThemeTokens>()!;
    return ColoredBox(
      color: themeTokens.background,
      child: Consumer<BookProvider>(
        // ignore: unnecessary_underscores
        builder: (_, provider, __) {
          List<BookModel> books = provider.books;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, position) {
              BookModel book = books[position];
              Uint8List? cover = book.cover;
              String title = book.title!;
              String description = book.description!;
              String reference = book.reference!;
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return BookDetail(bookData: book);
                      },
                    ),
                  );
                },

                child: Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: themeTokens.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      if (cover != null)
                        SizedBox(
                          width: 90,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.memory(cover, fit: BoxFit.cover),
                          ),
                        ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              title,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: themeTokens.onBackground,
                              ),
                            ),
                            Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              "Author: Dr. Alan Turing",
                              style: TextStyle(
                                fontSize: 18,
                                color: themeTokens.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              spacing: 8,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: themeTokens.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    child: Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      reference,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: themeTokens.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: themeTokens.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    child: Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      "TECH",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: themeTokens.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 16),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return AddBookSheet(
                                    id: book.id?.toInt(),
                                    title: book.title,
                                    description: book.description,
                                    reference: book.reference,
                                    authorId: book.authorId?.toInt(),
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              provider.deleteBook(1);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
