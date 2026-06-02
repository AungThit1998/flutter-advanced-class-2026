
import 'package:media_content_library_app/features/video/data/models/video_model.dart';

class VideoDetailStateModel {
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final VideoData? videoData;

  VideoDetailStateModel({
    this.isLoading = true,
    this.isError = false,
    this.isSuccess = false,
    this.videoData,
  });

  VideoDetailStateModel copWith({
    bool? isLoading,
    bool? isError,
    bool? isSuccess,
    VideoData? videoData,
  }) {
    return VideoDetailStateModel(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
      videoData: videoData ?? this.videoData,
    );
  }
}
