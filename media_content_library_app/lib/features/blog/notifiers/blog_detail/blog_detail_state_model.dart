
import '../../data/model/blog_model.dart';

class BlogDetailStateModel {
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final BlogData? blogData;

  BlogDetailStateModel({
     this.isLoading = true,
     this.isError = false,
     this.isSuccess = false,
     this.blogData,
  });

  BlogDetailStateModel copWith({
    bool? isLoading,
    bool? isError,
    bool? isSuccess,
    BlogData? blogData,
  }) {
    return BlogDetailStateModel(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
      blogData: blogData ?? this.blogData,
    );
  }
}
