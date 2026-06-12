import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/audio_model.dart';
import '../../data/service/audio_services.dart';
import 'audio_state_model.dart';

typedef AudioProvider = NotifierProvider<AudioNotifier, AudioStateModel>;

class AudioNotifier extends Notifier<AudioStateModel> {
  final AudioServices _audioServices = AudioServices();

  @override
  AudioStateModel build() {
    return AudioStateModel();
  }

  int _page = 1;

  void getAudioList() async {
    _page = 1;
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
      state = state.copyWith(isLoading: false, isFailed: true);
    }
  }

  void loadMore() async {
    try {
      _page = _page + 1;
      state = state.copyWith(isPaginateLoading: true);
      AudioModel audioModel = await _audioServices.getAudioList(page: _page);
      audioModel = audioModel.copyWith(
        data: [...?state.audioModel?.data, ...?audioModel.data],
      );
      state = state.copyWith(isPaginateLoading: false, audioModel: audioModel);
    } catch (e) {
      state = state.copyWith(isPaginateLoading: false);
    }
  }
}
