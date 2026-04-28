import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/blog/data/model/blog_model.dart';
import 'package:media_content_library_app/features/blog/data/service/blog_services.dart';

import 'blog_detail_state_model.dart';
typedef BlogDetailProvider = NotifierProvider<BlogDetailNotifier,BlogDetailStateModel>;
class BlogDetailNotifier extends Notifier<BlogDetailStateModel> {
  final BlogServices _blogServices = BlogServices();

  @override
  BlogDetailStateModel build() {
    return BlogDetailStateModel();
  }

  void getBlogDetail({required String? type, required String? id}) async {
    try {
      state = state.copWith(isLoading: true);
      if(type == null || id == null){
        state = state.copWith(isLoading: false, isError: true);
      }
      else {
        BlogData blogData = await _blogServices.getBlogDetail(
            type: type, id: id);
        state = state.copWith(isLoading: false, blogData: blogData);
      }
    } catch (e) {
      state = state.copWith(isLoading: false, isError: true);
    }
  }
}
