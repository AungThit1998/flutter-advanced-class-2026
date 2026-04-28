import 'package:dio/dio.dart';
import '../../../../const/apis/api_const.dart';
import '../../../../const/di/locator.dart';
import '../model/audio_model.dart';

class AudioServices {
  final Dio _dio = getIt.get();

  Future<AudioModel> getAudioList({int page = 1, int limit = 10}) async {
    final response = await _dio.get(
      "content",
      queryParameters: {"type": ApiConst.audio, "page": page, "limit": limit},
    );
    return AudioModel.fromJson(response.data);
  }
}
