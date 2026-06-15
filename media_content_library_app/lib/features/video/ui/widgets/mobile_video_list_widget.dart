import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/video/data/models/video_model.dart';
import 'package:media_content_library_app/features/video/notifiers/video_list/video_notifier.dart';
import 'package:media_content_library_app/features/video/notifiers/video_list/video_state_model.dart';
import 'package:media_content_library_app/features/video/ui/widgets/video_item.dart';

class MobileVideoList extends StatelessWidget {
  const MobileVideoList({
    super.key,
    required this.videoList,
    required this.colorScheme,
    required this.ref,
    required VideoProvider videoListProvider,
    required this.model,
  }) : _videoListProvider = videoListProvider;

  final List<VideoData> videoList;
  final ColorScheme colorScheme;
  final VideoStateModel model;
  final WidgetRef ref;
  final VideoProvider _videoListProvider;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videoList.length + 1,
      itemBuilder: (context, index) {
        if (index == videoList.length) {
          if (index == model.videoModel?.total) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Load Completed"),
              ),
            );
          }
          if (model.isPaginateLoading == false) {
            Future(() {
              ref.read(_videoListProvider.notifier).loadMore();
            });
          }
          return Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        VideoData videoData = videoList[index];
        return VideoItem(data: videoData, colorScheme: colorScheme);
      },
    );
  }
}
