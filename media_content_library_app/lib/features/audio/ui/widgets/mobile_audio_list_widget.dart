import 'package:flutter/material.dart';
import '../../../../features/audio/ui/widgets/audio_item.dart';
import '../../../../features/audio/data/model/audio_model.dart';

class MobileAudioList extends StatelessWidget {
  const MobileAudioList({
    super.key,
    required this.audioList,
    required this.colorScheme,
  });

  final List<AudioData> audioList;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: audioList.length,
      itemBuilder: (context, index) {
        AudioData data = audioList[index];
        return AudioItem(data: data, colorScheme: colorScheme);
      },
    );
  }
}
