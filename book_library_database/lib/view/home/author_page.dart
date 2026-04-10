
import 'dart:typed_data';

import 'package:book_library_database/const/theme/app_theme_token.dart';
import 'package:book_library_database/data/aithor_model.dart';
import 'package:book_library_database/provider/author_provider.dart';
import 'package:book_library_database/view/home/author_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorPage extends StatefulWidget {
  const AuthorPage({super.key});

  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
       Provider.of<AuthorProvider>(context,listen: false).getAllAuthor();
    });
  }
  @override
  Widget build(BuildContext context) {
    AppThemeTokens themeTokens = Theme.of(context).extension<AppThemeTokens>()!;
    return ColoredBox(
      color: themeTokens.background,
      child: Consumer<AuthorProvider>(
        builder: (_,provider, __){
          List<AuthorModel> authors = provider.authors;
          return ListView.builder(
              itemCount: authors.length,
              itemBuilder: (context,position){
                AuthorModel author = authors[position];
                Uint8List? photo = author.photo;
                String name = author.name;
                String description = author.description;
                return InkWell(
                  onTap: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (_){
                      return AuthorDetail(authorData: author);
                    }));
                  },

                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 16.0,left: 16,right: 16),
                    decoration: BoxDecoration(
                      color: themeTokens.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        if(photo != null)
                       CircleAvatar(
                         radius: 40,
                         backgroundImage: MemoryImage(photo!),
                       ),
                        SizedBox(width: 16,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                name,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: themeTokens.onBackground,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeTokens.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16,),
                        Column(
                          children: [
                            IconButton(onPressed: (){

                            }, icon: Icon(Icons.edit)),
                            IconButton(onPressed: (){
                               provider.deleteAuthor(author.id);
                            }, icon: Icon(Icons.delete))
                          ],
                        )

                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
