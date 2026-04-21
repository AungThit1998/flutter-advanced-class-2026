import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/blog/data/model/blog_model.dart';
import 'package:media_content_library_app/features/blog/notifiers/blog_list_notifier.dart';
import 'package:media_content_library_app/features/blog/notifiers/blog_list_state_model.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(_blogListProvider.notifier).getBLogList();
    });
  }
  @override
  Widget build(BuildContext context) {
    BlogListStateModel model = ref.watch(_blogListProvider);
    if(model.isLoading){
      return Center(child: CircularProgressIndicator());
    }
    if(model.isError){
      return Column(
        children: [
          Text("Something wrong"),
          SizedBox(height: 8,),
          OutlinedButton(onPressed: (){
            ref.read(_blogListProvider.notifier).getBLogList();
          }, child: Text("Try Again"))
        ],
      );
    }
    else{
      List<BlogData>? blogList = model.blogModel?.data ?? [];
      if(blogList.isEmpty){
        return Center(
          child: Text("Empty Blog List"),
        );
      }
      return ListView.builder(
        itemCount: blogList.length,
          itemBuilder: (context,index){
            BlogData blog = blogList[index];
            String? coverImage = blog.coverImage;
            String? comments = "${blog.comments?.length} Comments";
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                coverImage != null ?  Image.network(coverImage) :
                     Icon(Icons.image),
                  Text(blog.title ?? ""),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          blog.author ?? ""
                        ),
                        Text(comments)
                      ],
                    ),
                  )
                ],
              ),
            );
          });
    }
  }
}
