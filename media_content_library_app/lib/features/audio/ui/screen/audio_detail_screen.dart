import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/const/widgets/common/try_again_widget.dart';
import 'package:media_content_library_app/features/audio/data/model/audio_model.dart';
import 'package:media_content_library_app/features/audio/notifiers/audio_detail/audio_detail_state_model.dart';

import '../../notifiers/audio_detail/audio_detail_notifier.dart';

class AudioDetailScreen extends ConsumerStatefulWidget {
  const AudioDetailScreen({super.key,required  this.id});
  final String? id;

  @override
  ConsumerState<AudioDetailScreen> createState() => _AudioDetailScreenState();
}

class _AudioDetailScreenState extends ConsumerState<AudioDetailScreen> {
  final AudioDetailProvider _audioDetailProvider = AudioDetailProvider(() => AudioDetailNotifier());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(_audioDetailProvider.notifier).getAudio(widget.id);
    });
  }
  @override
  Widget build(BuildContext context) {
    AudioDetailStateModel stateModel = ref.watch(_audioDetailProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(stateModel.audioData?.title ?? "...."),
      ),
      body: _audioDetailBody(),
    );
  }
  Widget _audioDetailBody(){
    AudioDetailStateModel stateModel = ref.watch(_audioDetailProvider);
    if(stateModel.isLoading){
      return Center(child: CircularProgressIndicator());
    }
    else if(stateModel.isError){
      return TryAgainWidget(onTryAgain: (){
        ref.read(_audioDetailProvider.notifier).getAudio(widget.id);
      });
    }
    AudioData? audioData = stateModel.audioData;
    return Center(
      child: Column(
        children: [
          Text(audioData?.artist ?? ""),
        ],
      ),
    );
  }
}
