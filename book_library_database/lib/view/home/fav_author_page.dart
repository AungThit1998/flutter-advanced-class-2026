import 'dart:typed_data';

import 'package:book_library_database/const/theme/app_theme_token.dart';
import 'package:book_library_database/data/aithor_model.dart';
import 'package:book_library_database/provider/author_provider.dart';
import 'package:book_library_database/view/home/author_detail.dart';
import 'package:book_library_database/view/home/widgets/add_author_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavAuthorPage extends StatefulWidget {
  const FavAuthorPage({super.key});

  @override
  State<FavAuthorPage> createState() => _FavAuthorPageState();
}

class _FavAuthorPageState extends State<FavAuthorPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthorProvider>(context, listen: false).getAllFavAuthor();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppThemeTokens themeTokens = Theme.of(context).extension<AppThemeTokens>()!;
    return Scaffold(
      appBar: AppBar(),
      body: ColoredBox(
        color: themeTokens.background,
        child: Consumer<AuthorProvider>(
          // ignore: unnecessary_underscores
          builder: (_, provider, __) {
            List<AuthorModel> authors = provider.authors;
            return ListView.builder(
              itemCount: authors.length,
              itemBuilder: (context, position) {
                AuthorModel author = authors[position];
                Uint8List? photo = author.photo;
                String name = author.name;
                String description = author.description;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return AuthorDetail(authorData: author);
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
                        if (photo != null)
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: MemoryImage(photo),
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
                                name,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: themeTokens.onBackground,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: themeTokens.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: themeTokens.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 6.0,
                                  ),
                                  child: Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    "EDUCATION",
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
                                    return AddAuthorSheet(
                                      id: author.id,
                                      name: author.name,
                                      description: author.description,
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                provider.deleteAuthor(author.id);
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
      ),
    );
  }
}
