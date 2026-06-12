import 'package:media_content_library_app/features/audio/data/model/audio_model.dart';

import '../../../blog/data/model/blog_model.dart';

class AudioStateModel {
  final bool isLoading;
  final bool isPaginateLoading;
  final bool isFailed;
  final bool isSuccess;
  final AudioModel? audioModel;

  AudioStateModel({
    this.isLoading = true,
    this.isPaginateLoading = false,
    this.isFailed = false,
    this.isSuccess = false,
    this.audioModel,
  });

  AudioStateModel copyWith({
    bool? isLoading,
    bool? isPaginateLoading,
    bool? isFailed,
    bool? isSuccess,
    AudioModel? audioModel,
  }) {
    return AudioStateModel(
      isLoading: isLoading ?? this.isLoading,
      isPaginateLoading: isPaginateLoading ?? this.isPaginateLoading,
      isFailed: isFailed ?? this.isFailed,
      isSuccess: isSuccess ?? this.isSuccess,
      audioModel: audioModel ?? this.audioModel,
    );
  }
}
