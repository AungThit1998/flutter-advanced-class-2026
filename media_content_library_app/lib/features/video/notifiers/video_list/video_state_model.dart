import 'package:media_content_library_app/features/video/data/models/video_model.dart';

class VideoStateModel {
  final bool isLoading;
  final bool isPaginateLoading;
  final bool isFailed;
  final bool isSuccess;
  final VideoModel? videoModel;

  VideoStateModel({
    this.isLoading = true,
    this.isFailed = false,
    this.isSuccess = false,
    this.videoModel,
    this.isPaginateLoading = false,
  });

  VideoStateModel copyWith({
    bool? isLoading,
    bool? isPaginateLoading,
    bool? isFailed,
    bool? isSuccess,
    VideoModel? videoModel,
  }) {
    return VideoStateModel(
      isLoading: isLoading ?? this.isLoading,
      isFailed: isFailed ?? this.isFailed,
      isSuccess: isSuccess ?? this.isSuccess,
      videoModel: videoModel ?? this.videoModel,
      isPaginateLoading: isPaginateLoading ?? this.isPaginateLoading,
    );
  }
}
