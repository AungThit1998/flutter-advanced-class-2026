import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/const/apis/api_const.dart';
import 'package:media_content_library_app/features/audio/data/model/audio_model.dart';

import '../../data/service/audio_services.dart';
import 'audio_detail_state_model.dart';
typedef AudioDetailProvider = NotifierProvider<AudioDetailNotifier,AudioDetailStateModel>;
class AudioDetailNotifier extends Notifier<AudioDetailStateModel> {
  final AudioServices _audioServices = AudioServices();

  @override
  AudioDetailStateModel build() {
    return AudioDetailStateModel();
  }

  void getAudio(String? id) async {
    state = state.copWith(isLoading: true, isSuccess: false, isError: false);
    if(id == null){
      state = state.copWith(isLoading: false,isError: true);
      return;
    }
    try {
      AudioData audioData = await _audioServices.getBlogDetail(
        type: ApiConst.audio,
        id: id,
      );
      state = state.copWith(
        isLoading: false,
        isSuccess: true,
        audioData: audioData,
      );
    } catch (e) {
      state = state.copWith(isLoading: false, isError: true);
    }
  }
}
