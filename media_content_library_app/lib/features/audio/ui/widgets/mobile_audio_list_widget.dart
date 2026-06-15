import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/audio/notifiers/audio_list/audio_state_model.dart';
import '../../../../features/audio/ui/widgets/audio_item.dart';
import '../../../../features/audio/data/model/audio_model.dart';
import '../../notifiers/audio_list/audio_notifier.dart';

class MobileAudioList extends StatelessWidget {
  const MobileAudioList({
    super.key,
    required this.audioList,
    required this.colorScheme,
    required this.ref,
    required AudioProvider audioListProvider,
    required this.model,
  }) : _audioListProvider = audioListProvider;

  final List<AudioData> audioList;
  final ColorScheme colorScheme;
  final AudioStateModel model;
  final WidgetRef ref;
  final AudioProvider _audioListProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: audioList.length + 1,
      itemBuilder: (context, index) {
        if (index == audioList.length) {
          if (index == model.audioModel?.total) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Load Completed"),
              ),
            );
          }
          if (model.isPaginateLoading == false) {
            Future(() {
              ref.read(_audioListProvider.notifier).loadMore();
            });
          }
          return Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        AudioData data = audioList[index];
        return AudioItem(data: data, colorScheme: colorScheme);
      },
    );
  }
}
