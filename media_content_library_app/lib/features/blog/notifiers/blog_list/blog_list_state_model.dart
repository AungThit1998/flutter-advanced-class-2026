import 'package:media_content_library_app/features/blog/data/model/blog_model.dart';

class BlogListStateModel {
  final BlogModel? blogModel;
  final bool isLoading;
  final bool isPaginateLoading;
  final bool isError;
  final bool isSuccess;

  BlogListStateModel({
     this.blogModel,
     this.isLoading = true,
     this.isPaginateLoading = false,
     this.isError = false,
     this.isSuccess = false,
  });

  BlogListStateModel copyWith({
    BlogModel? blogModel,
    bool? isLoading,
    bool? isPaginateLoading,
    bool? isError,
    bool? isSuccess,
  }) {
    return BlogListStateModel(
      blogModel: blogModel ?? this.blogModel,
      isLoading: isLoading ?? this.isLoading,
      isPaginateLoading: isPaginateLoading ?? this.isPaginateLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
