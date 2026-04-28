import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/audio_model.dart';
import '../data/service/audio_services.dart';
import 'audio_state_model.dart';

class AudioNotifier extends Notifier<AudioStateModel> {
  final AudioServices _audioServices = AudioServices();

  @override
  AudioStateModel build() {
    return AudioStateModel();
  }

  void getAudioList() async {
    try {
      state = state.copyWith(
        isLoading: true,
        isSuccess: false,
        isFailed: false,
      );
      AudioModel audioModel = await _audioServices.getAudioList();
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        audioModel: audioModel,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isFailed: true,
      );
    }
  }
}
