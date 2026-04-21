
import '../data/model/blog_model.dart';
import '../data/service/blog_services.dart';
import 'blog_list_state_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef BlogListProvider = NotifierProvider<BlogListNotifier,BlogListStateModel>;
class BlogListNotifier extends Notifier<BlogListStateModel>{
  BlogServices blogServices = BlogServices();
  @override
  BlogListStateModel build() {
   return BlogListStateModel();
  }
  void getBLogList() async{
    try{
      state = state.copyWith(
        isLoading: true,
        isSuccess: false,
        isError: false,
      );
      BlogModel blogModel = await blogServices.getBlogList();
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        blogModel: blogModel,
      );
    }
    catch(e){
      state.copyWith(
        isError:  true,
        isLoading: false,
        isSuccess: false,
        isPaginateLoading: false,
      );
    }
  }

}