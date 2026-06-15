import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/video_model.dart';
import '../../data/services/video_api_services.dart';
import 'video_state_model.dart';

typedef VideoProvider = NotifierProvider<VideoNotifier, VideoStateModel>;

class VideoNotifier extends Notifier<VideoStateModel> {
  final VideoApiServices _services = VideoApiServices();
  @override
  VideoStateModel build() {
    return VideoStateModel();
  }

  int _page = 1;
  void getVideoList() async {
    _page = 1;
    try {
      state = state.copyWith(
        isLoading: true,
        isSuccess: false,
        isFailed: false,
      );
      VideoModel videoModel = await _services.getVideoList();
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        videoModel: videoModel,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isFailed: true);
    }
  }

  void loadMore() async {
    try {
      _page = _page + 1;
      state = state.copyWith(isPaginateLoading: true);
      VideoModel videoModel = await _services.getVideoList(page: _page);
      videoModel = videoModel.copyWith(
        data: [...?state.videoModel?.data, ...?videoModel.data],
      );
      state = state.copyWith(isPaginateLoading: false, videoModel: videoModel);
    } catch (e) {
      state = state.copyWith(isPaginateLoading: false);
    }
  }
}
