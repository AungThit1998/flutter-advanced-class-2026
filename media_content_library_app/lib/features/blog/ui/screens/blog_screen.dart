import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/const/responsive/responsive_layout.dart';
import 'package:media_content_library_app/const/widgets/common/try_again_widget.dart';
import 'package:media_content_library_app/features/blog/data/model/blog_model.dart';
import 'package:media_content_library_app/features/blog/notifiers/blog_list/blog_list_notifier.dart';
import 'package:media_content_library_app/features/blog/notifiers/blog_list/blog_list_state_model.dart';
import 'package:media_content_library_app/features/blog/ui/widgets/blog_item.dart';

import '../widgets/desktop_blog_list_widget.dart';
import '../widgets/mobile_blog_list_widget.dart';

class BlogScreen extends ConsumerStatefulWidget {
  const BlogScreen({super.key});

  @override
  ConsumerState<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends ConsumerState<BlogScreen> {
  final BlogListProvider _blogListProvider = BlogListProvider(
    () => BlogListNotifier(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_blogListProvider.notifier).getBLogList();
    });
  }

  @override
  Widget build(BuildContext context) {
    BlogListStateModel model = ref.watch(_blogListProvider);
    if (model.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (model.isError) {
      return TryAgainWidget(onTryAgain: (){
        ref.read(_blogListProvider.notifier).getBLogList();
      });
    } else {
      List<BlogData>? blogList = model.blogModel?.data ?? [];
      if (blogList.isEmpty) {
        return Center(child: Text("Empty Blog List"));
      }
      return ResponsiveLayout(
        tablet: DesktopBlogList(
          blogList: blogList,
          model: model,
          ref: ref,
          blogListProvider: _blogListProvider,
        ),
        mobile: MobileBlogList(
          blogList: blogList,
          model: model,
          ref: ref,
          blogListProvider: _blogListProvider,
        ),
      );
    }
  }
}
