import '../../data/model/audio_model.dart';

class AudioDetailStateModel {
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final AudioData? audioData;

  AudioDetailStateModel({
    this.isLoading = true,
    this.isError = false,
    this.isSuccess = false,
    this.audioData,
  });

  AudioDetailStateModel copWith({
    bool? isLoading,
    bool? isError,
    bool? isSuccess,
    AudioData? audioData,
  }) {
    return AudioDetailStateModel(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
      audioData: audioData ?? this.audioData,
    );
  }
}
