import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../const/widgets/common/try_again_widget.dart';
import '../../data/models/video_model.dart';
import '../../notifiers/video_list/video_notifier.dart';
import '../../notifiers/video_list/video_state_model.dart';
import '../widgets/video_item.dart';

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
    return ListView.builder(
      itemCount: videoList.length,
      itemBuilder: (context, position) {
        VideoData videoData = videoList[position];
        return VideoItem(data: videoData, colorScheme: colorScheme);
      },
    );
  }
}
