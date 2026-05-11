import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_content_library_app/const/widgets/common/try_again_widget.dart';
import 'package:media_content_library_app/features/audio/data/model/audio_model.dart';
import 'package:media_content_library_app/features/audio/notifiers/audio_detail/audio_detail_state_model.dart';

import '../../notifiers/audio_detail/audio_detail_notifier.dart';

class AudioDetailScreen extends ConsumerStatefulWidget {
  const AudioDetailScreen({super.key, required this.id});

  final String? id;

  @override
  ConsumerState<AudioDetailScreen> createState() => _AudioDetailScreenState();
}

class _AudioDetailScreenState extends ConsumerState<AudioDetailScreen> {
  final AudioDetailProvider _audioDetailProvider = AudioDetailProvider(
    () => AudioDetailNotifier(),
  );
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _url;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_audioDetailProvider.notifier).getAudio(widget.id);
    });
  }
  
  @override
  void dispose() {
    super.dispose();
    _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    AudioDetailStateModel stateModel = ref.watch(_audioDetailProvider);
    ref.listen(_audioDetailProvider, (oldState, newState) {
      if (newState.isSuccess) {
        _loadAudio(newState.audioData?.url);
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text(stateModel.audioData?.title ?? "....")),
      body: _audioDetailBody(),
    );
  }

  Widget _audioDetailBody() {
    AudioDetailStateModel stateModel = ref.watch(_audioDetailProvider);
    if (stateModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (stateModel.isError) {
      return TryAgainWidget(
        onTryAgain: () {
          ref.read(_audioDetailProvider.notifier).getAudio(widget.id);
        },
      );
    }
    AudioData? audioData = stateModel.audioData;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            Text(audioData?.artist ?? ""),
            StreamBuilder<Duration>(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                Duration current = snapshot.data ?? Duration.zero;
                Duration length = _audioPlayer.duration ?? Duration.zero;

                double currentPosition = current.inSeconds.toDouble();
                double audioLength = length.inSeconds.toDouble();

                String displayTotal =
                    "${length.inMinutes}:${(length.inSeconds % 60).toInt()}";
                String displayCurrent =
                    "${current.inMinutes}:${(current.inSeconds % 60).toInt()}";

                return Column(
                  children: [
                    Slider(
                      value: currentPosition,
                      max: audioLength,
                      onChanged: (value) {
                        _audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                    SizedBox(height: 4),
                    Text('$displayCurrent/$displayTotal'),
                  ],
                );
              },
            ),
            StreamBuilder<PlayerState>(stream: _audioPlayer.playerStateStream, builder: (context,snapshot){
              PlayerState? playerState = snapshot.data;
              bool isPlaying = playerState?.playing ?? false;
              return IconButton(onPressed: (){
                if(isPlaying){
                  _audioPlayer.pause();
                }
                else if(_audioPlayer.processingState == ProcessingState.ready){
                  _audioPlayer.play();
                }
              }, icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow_rounded));
            })
          ],
        ),
      ),
    );
  }

  void _loadAudio(String? url) {
    if (url == null || url.isEmpty || _url == url) {
      return;
    }
    _url = url;
    _audioPlayer.setUrl(_url!);
  }
}
