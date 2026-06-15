import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/const/responsive/responsive_layout.dart';
import 'package:media_content_library_app/features/video/ui/widgets/desktop_video_list_widget.dart';
import 'package:media_content_library_app/features/video/ui/widgets/mobile_video_list_widget.dart';
import '../../../../const/widgets/common/try_again_widget.dart';
import '../../data/models/video_model.dart';
import '../../notifiers/video_list/video_notifier.dart';
import '../../notifiers/video_list/video_state_model.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  final VideoProvider _videoProvider = VideoProvider(() => VideoNotifier());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_videoProvider.notifier).getVideoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    VideoStateModel videoStateModel = ref.watch(_videoProvider);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (videoStateModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (videoStateModel.isFailed) {
      return TryAgainWidget(
        onTryAgain: () {
          ref.read(_videoProvider.notifier).getVideoList();
        },
      );
    }
    List<VideoData> videoList = videoStateModel.videoModel?.data ?? [];

    if (videoList.isEmpty) {
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
              "No Video Found",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "There are no video items available at the moment.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ResponsiveLayout(
      mobile: MobileVideoList(
        videoList: videoList,
        colorScheme: colorScheme,
        ref: ref,
        model: videoStateModel,
        videoListProvider: _videoProvider,
      ),
      desktop: DesktopVideoList(
        videoList: videoList,
        colorScheme: colorScheme,
        ref: ref,
        videoProvider: _videoProvider,
        model: videoStateModel,
      ),
    );
  }
}
