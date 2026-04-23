import '../data/model/blog_model.dart';
import '../data/service/blog_services.dart';
import 'blog_list_state_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef BlogListProvider =
NotifierProvider<BlogListNotifier, BlogListStateModel>;

class BlogListNotifier extends Notifier<BlogListStateModel> {
  BlogServices blogServices = BlogServices();

  @override
  BlogListStateModel build() {
    return BlogListStateModel();
  }

  int _page = 1;

  void getBLogList() async {
    _page = 1;
    try {
      state = state.copyWith(isLoading: true, isSuccess: false, isError: false);
      BlogModel blogModel = await blogServices.getBlogList();
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        blogModel: blogModel,
      );
    } catch (e) {
      state.copyWith(
        isError: true,
        isLoading: false,
        isSuccess: false,
        isPaginateLoading: false,
      );
    }
  }

  void loadMore() async {
    try {
      _page = _page + 1;
      state = state.copyWith(isPaginateLoading: true);
      BlogModel blogModel = await blogServices.getBlogList(
        page: _page,
      );
      blogModel = blogModel.copyWith(
          data: [...?state.blogModel?.data,
            ...?blogModel.data]
      );
      state = state.copyWith(
        isPaginateLoading: false,
        blogModel: blogModel,
      );
    }
    catch (e) {
      state = state.copyWith(isPaginateLoading: false);
    }
  }
}
