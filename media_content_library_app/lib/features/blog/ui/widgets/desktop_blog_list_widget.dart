import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/blog_model.dart';
import '../../notifiers/blog_list/blog_list_notifier.dart';
import '../../notifiers/blog_list/blog_list_state_model.dart';
import 'blog_item.dart';

class DesktopBlogList extends StatefulWidget {
  const DesktopBlogList({
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
  State<DesktopBlogList> createState() => _DesktopBlogListState();
}

class _DesktopBlogListState extends State<DesktopBlogList> {
  bool _loadCompleted = false;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            child: GridView.builder(
              controller: _scrollController,
              itemCount: widget.blogList.length + 1,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350,
                mainAxisExtent: 300,
              ),
              itemBuilder: (context, index) {
                if (index == widget.blogList.length) {
                  bool isLoadCompleted = index == widget.model.blogModel?.total;
                  if (_loadCompleted != isLoadCompleted) {
                    Future((){
                      setState(() {
                        _loadCompleted = isLoadCompleted;
                      });
                    });
                  }
                  if (widget.model.isPaginateLoading == false &&
                      !isLoadCompleted) {
                    Future(() {
                      widget.ref
                          .read(widget._blogListProvider.notifier)
                          .loadMore();
                    });
                  }
                  return SizedBox.shrink();
                }
                BlogData blogData = widget.blogList[index];
                return BlogItem(blogData: blogData);
              },
            ),
          ),
        ),
        if (_loadCompleted)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Load Completed"),
            ),
          ),
        if (widget.model.isPaginateLoading)
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
