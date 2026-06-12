import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/audio/ui/widgets/desktop_audio_list_widget.dart';
import '../../../../const/responsive/responsive_layout.dart';
import '../../../../const/widgets/common/try_again_widget.dart';
import '../../../../features/audio/data/model/audio_model.dart';
import '../../../../features/audio/notifiers/audio_list/audio_notifier.dart';
import '../../../../features/audio/notifiers/audio_list/audio_state_model.dart';
import '../../../../features/audio/ui/widgets/mobile_audio_list_widget.dart';
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

    if (audioList.isEmpty) {
      return Center(child: Text("Empty Audio List"));
    }

    return ResponsiveLayout(
      mobile: MobileAudioList(audioList: audioList, colorScheme: colorScheme),
      desktop: DesktopAudioList(
        audioList: audioList,
        colorScheme: colorScheme,
        ref: ref,
        audioProvider: _audioProvider,
        model: stateModel,
      ),
    );
  }
}
