import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/blog_model.dart';
import '../../notifiers/blog_list/blog_list_notifier.dart';
import '../../notifiers/blog_list/blog_list_state_model.dart';
import 'blog_item.dart';

class MobileBlogList extends StatelessWidget {
  const MobileBlogList({
    super.key,
    required this.blogList,
    required this.model,
    required this.ref,
    required BlogListProvider blogListProvider,
  }) : _blogListProvider = blogListProvider;

  final List<BlogData> blogList;
  final BlogListStateModel model;
  final WidgetRef ref;
  final BlogListProvider _blogListProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: blogList.length + 1,
      itemBuilder: (context, index) {
        if (index == blogList.length) {
          if (index == model.blogModel?.total) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Load Completed"),
              ),
            );
          }
          if (model.isPaginateLoading == false) {
            Future(() {
              ref.read(_blogListProvider.notifier).loadMore();
            });
          }
          return Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }

        BlogData blog = blogList[index];
        String? coverImage = blog.coverImage;
        String? comments = "${blog.comments?.length} Comments";
        return BlogItem(blogData: blog);
      },
    );
  }
}
