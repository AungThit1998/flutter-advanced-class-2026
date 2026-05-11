import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/video_model.dart';
import '../../data/services/video_api_services.dart';
import 'video_state_model.dart';

typedef VideoProvider = NotifierProvider<VideoNotifier,VideoStateModel>;
class VideoNotifier extends Notifier<VideoStateModel>{
  final VideoApiServices _services = VideoApiServices();
  @override
  VideoStateModel build() {
    return VideoStateModel();
  }
  void getVideoList() async{
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
      state = state.copyWith(
        isLoading: false,
        isFailed: true,
      );
    }
  }

}