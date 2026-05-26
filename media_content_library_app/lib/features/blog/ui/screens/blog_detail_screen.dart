import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/comments/data/models/comment_model.dart';
import 'package:media_content_library_app/features/comments/ui/comment_dialog.dart';

import '../../../../const/widgets/common/comment_floating_action_button.dart';
import '../../../../const/widgets/web_view/web_view_common.dart';
import '../../notifiers/blog_detail/blog_detail_notifier.dart';
import '../../notifiers/blog_detail/blog_detail_state_model.dart';

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
    String? title = detailStateModel.blogData?.title;
    return Scaffold(
      appBar: AppBar(title: title != null ? Text(title) : SizedBox.shrink()),
      body: _blogDetailBody(),
      floatingActionButton: title != null
          ? CommentFloatingActionButton(type: widget.type, id: widget.id, title: title)
          : null,
    );
  }

  Widget _blogDetailBody() {
    BlogDetailStateModel detailStateModel = ref.watch(_blogDetailProvider);
    String content = detailStateModel.blogData?.content ?? '';
    if (detailStateModel.isLoading) {
      return Center(child: CircularProgressIndicator());
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
    return content.isNotEmpty
        ? MyWebView(htmlString: detailStateModel.blogData?.content ?? '')
        : SizedBox.shrink();
  }
}