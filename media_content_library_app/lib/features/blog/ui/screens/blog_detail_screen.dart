import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/blog/notifiers/blog_detail/blog_detail_notifier.dart';
import 'package:media_content_library_app/features/blog/notifiers/blog_detail/blog_detail_state_model.dart';
import 'package:media_content_library_app/features/blog/notifiers/blog_list/blog_list_notifier.dart';

class BlogDetailScreen extends ConsumerStatefulWidget {
  const BlogDetailScreen({super.key, required this.type, required this.id});

  final String? type;
  final String? id;

  @override
  ConsumerState<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends ConsumerState<BlogDetailScreen> {
  final BlogDetailProvider _blogDetailProvider = BlogDetailProvider(
    () => BlogDetailNotifier(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getDetail();
    });
  }

  void _getDetail() {
    ref
        .read(_blogDetailProvider.notifier)
        .getBlogDetail(type: widget.type, id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    BlogDetailStateModel detailStateModel = ref.watch(_blogDetailProvider);
    if (detailStateModel.isLoading) {
      Center(child: CircularProgressIndicator());
    }
    if (detailStateModel.isError) {
      return Column(
        children: [
          Text("Something wrong"),
          SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              _getDetail();
            },
            child: Text("Try Again"),
          ),
        ],
      );
    }
    return Text(detailStateModel.blogData?.content ?? "");
  }
}
