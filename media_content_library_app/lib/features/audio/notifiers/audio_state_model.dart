import 'package:media_content_library_app/features/audio/data/model/audio_model.dart';

import '../../blog/data/model/blog_model.dart';

class AudioStateModel {
  final bool isLoading;
  final bool isFailed;
  final bool isSuccess;
  final AudioModel? audioModel;

  AudioStateModel({
    this.isLoading = true,
    this.isFailed = false,
    this.isSuccess = false,
    this.audioModel,
  });

  AudioStateModel copyWith({
    bool? isLoading,
    bool? isFailed,
    bool? isSuccess,
    AudioModel? audioModel,
  }) {
    return AudioStateModel(
      isLoading: isLoading ?? this.isLoading,
      isFailed: isFailed ?? this.isFailed,
      isSuccess: isSuccess ?? this.isSuccess,
      audioModel: audioModel ?? this.audioModel,
    );
  }
}
