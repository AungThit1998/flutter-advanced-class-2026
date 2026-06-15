import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/audio/ui/widgets/desktop_audio_list_widget.dart';
import '../../../../const/responsive/responsive_layout.dart';
import '../../../../const/widgets/common/try_again_widget.dart';
import '../../../../features/audio/data/model/audio_model.dart';
import '../../../../features/audio/notifiers/audio_list/audio_notifier.dart';
import '../../../../features/audio/notifiers/audio_list/audio_state_model.dart';
import '../../../../features/audio/ui/widgets/mobile_audio_list_widget.dart';

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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Loading Audio...",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note_outlined,
              size: 80,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "No Audio Found",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "There are no audio items available at the moment.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
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
