import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/const/widgets/common/try_again_widget.dart';
import 'package:media_content_library_app/features/audio/data/model/audio_model.dart';
import 'package:media_content_library_app/features/audio/notifiers/audio_notifier.dart';
import 'package:media_content_library_app/features/audio/notifiers/audio_state_model.dart';
import 'package:media_content_library_app/features/blog/ui/widgets/blog_cover_image.dart';

import '../widgets/audio_item.dart';

class AudioScreen extends ConsumerStatefulWidget {
  const AudioScreen({super.key});

  @override
  ConsumerState<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends ConsumerState<AudioScreen> {
  final AudioProvider _audioProvider = AudioProvider(() {
    return AudioNotifier();
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_audioProvider.notifier).getAudioList();
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    AudioStateModel stateModel = ref.watch(_audioProvider);
    if (stateModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (stateModel.isFailed) {
      return TryAgainWidget(
        onTryAgain: () {
          ref.read(_audioProvider.notifier).getAudioList();
        },
      );
    }
    List<AudioData> audioList =
        ref.watch(_audioProvider).audioModel?.data ?? [];
    return ListView.builder(
      itemCount: audioList.length,
      itemBuilder: (context, index) {
        AudioData data = audioList[index];
        return AudioItem(data: data, colorScheme: colorScheme);
      },
    );
  }
}

