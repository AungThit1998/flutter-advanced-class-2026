import 'package:dio/dio.dart';
import '../../../../const/apis/api_const.dart';
import '../../../../const/di/locator.dart';
import '../models/video_model.dart';

class VideoApiServices {
  final Dio _dio = getIt.get();

  Future<VideoModel> getVideoList({int page = 1, int limit = 10}) async {
    final response = await _dio.get(
      "content",
      queryParameters: {"type": ApiConst.video, "page": page, "limit": limit},
    );
    return VideoModel.fromJson(response.data);
  }
  Future<VideoData> getVideoDetail({required String type,required String id}) async{
    final response = await _dio.get("content/$type/$id");
    return VideoData.fromJson(response.data);
  }
}
