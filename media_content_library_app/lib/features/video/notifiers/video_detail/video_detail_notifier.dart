
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/apis/api_const.dart';
import '../../data/models/video_model.dart';
import '../../data/services/video_api_services.dart';
import 'video_detail_state_model.dart';

typedef VideoDetailProvider = NotifierProvider<VideoDetailNotifier,VideoDetailStateModel>;
class VideoDetailNotifier extends Notifier<VideoDetailStateModel> {
  final VideoApiServices _videoApiServices = VideoApiServices();

  @override
  VideoDetailStateModel build() {
    return VideoDetailStateModel();
  }

  void geVideo(String? id) async {
    state = state.copWith(isLoading: true, isSuccess: false, isError: false);
    if(id == null){
      state = state.copWith(isLoading: false,isError: true);
      return;
    }
    try {
      VideoData videoData = await _videoApiServices.getVideoDetail(
        type: ApiConst.video,
        id: id,
      );
      state = state.copWith(
        isLoading: false,
        isSuccess: true,
        videoData: videoData,
      );
    } catch (e) {
      state = state.copWith(isLoading: false, isError: true);
    }
  }
}
