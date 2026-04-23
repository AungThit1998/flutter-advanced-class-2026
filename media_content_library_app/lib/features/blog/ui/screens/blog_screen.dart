import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/blog/data/model/blog_model.dart';
import 'package:media_content_library_app/features/blog/notifiers/blog_list_notifier.dart';
import 'package:media_content_library_app/features/blog/notifiers/blog_list_state_model.dart';
import 'package:media_content_library_app/features/blog/ui/widgets/blog_item.dart';

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
        itemCount: blogList.length + 1,
          itemBuilder: (context,index){
            if(index == blogList.length){
               if(index == model.blogModel?.total){
                 return Center(
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text("Load Complete"),
                   ),
                 );
               }
               if(model.isPaginateLoading == false){
                Future((){
                  ref.read(_blogListProvider.notifier).loadMore();
                });
               }
               return Container(
                    padding: EdgeInsets.all(8.0),
                   alignment: Alignment.center,
                   child: CircularProgressIndicator());
            }

            BlogData blog = blogList[index];
            String? coverImage = blog.coverImage;
            String? comments = "${blog.comments?.length} Comments";
            return BlogItem(blogData: blog);
          });
    }
  }
}
