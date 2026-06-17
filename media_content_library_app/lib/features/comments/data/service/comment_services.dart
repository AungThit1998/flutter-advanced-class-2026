import 'package:dio/dio.dart';
import 'package:media_content_library_app/const/apis/api_const.dart';
import 'package:media_content_library_app/const/storage/user_session.dart';

import '../../../../const/di/locator.dart';
import '../models/add_comment_response.dart';

class CommentServices {
  final Dio _dio = getIt();
  final UserSession _userSession = UserSession();

  Future<AddCommentResponse> addComment({
    required String text,
    required String type,
    required String id,
  }) async {
    String? token = await _userSession.getToken();
    if (token?.isNotEmpty == true) {
      _dio.options.headers = {"Authorization": "Bearer $token"};
      final response = await _dio.post(
        ApiConst.addComment(type, id),
        data: {"text": text},
      );
      return AddCommentResponse.fromJson(response.data);
    } else {
      throw Exception("User Not Logged in");
    }
  }

  Future<AddCommentResponse> editComment({
    required String text,
    required String type,
    required String id,
    required String commentId,
  }) async {
    String? token = await _userSession.getToken();
    if (token?.isNotEmpty == true) {
      _dio.options.headers = {"Authorization": "Bearer $token"};
      final response = await _dio.put(
        ApiConst.editComment(type, id, commentId),
        data: {"text": text},
      );
      return AddCommentResponse.fromJson(response.data);
    } else {
      throw Exception("User Not Logged in");
    }
  }

  Future<AddCommentResponse> deleteComment({
    required String text,
    required String type,
    required String id,
    required String commentId,
  }) async {
    String? token = await _userSession.getToken();
    if (token?.isNotEmpty == true) {
      _dio.options.headers = {"Authorization": "Bearer $token"};
      final response = await _dio.delete(
        ApiConst.deleteComment(type, id, commentId),
        data: {"text": text},
      );
      return AddCommentResponse.fromJson(response.data);
    } else {
      throw Exception("User Not Logged in");
    }
  }
}
