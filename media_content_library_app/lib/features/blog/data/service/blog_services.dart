import 'package:dio/dio.dart';
import '../../../../const/apis/api_const.dart';
import '../../../../const/di/locator.dart';
import '../model/blog_model.dart';

class BlogServices {
  final Dio _dio = getIt.get();

  Future<BlogModel> getBlogList({int page = 1, int limit = 10}) async {
    final response = await _dio.get(
      "content",
      queryParameters: {"type": ApiConst.blog, "page": page, "limit": limit},
    );
    return BlogModel.fromJson(response.data);
  }
}
