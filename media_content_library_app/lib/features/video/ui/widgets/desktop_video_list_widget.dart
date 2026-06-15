import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/video/data/models/video_model.dart';
import 'package:media_content_library_app/features/video/notifiers/video_list/video_notifier.dart';
import 'package:media_content_library_app/features/video/notifiers/video_list/video_state_model.dart';
import 'package:media_content_library_app/features/video/ui/widgets/video_item.dart';

class DesktopVideoList extends StatefulWidget {
  const DesktopVideoList({
    super.key,
    required this.videoList,
    required this.colorScheme,
    required this.ref,
    required VideoProvider videoProvider,
    required this.model,
  }) : _videoProvider = videoProvider;

  final List<VideoData> videoList;
  final ColorScheme colorScheme;
  final WidgetRef ref;
  final VideoProvider _videoProvider;
  final VideoStateModel model;

  @override
  State<DesktopVideoList> createState() => _DesktopVideoListState();
}

class _DesktopVideoListState extends State<DesktopVideoList> {
  final ScrollController _scrollController = ScrollController();
  bool _loadCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 320,
                mainAxisExtent: 280,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: widget.videoList.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.videoList.length) {
                  bool isLoadCompleted =
                      index == widget.model.videoModel?.total;
                  if (_loadCompleted != isLoadCompleted) {
                    Future(() {
                      setState(() {
                        _loadCompleted = isLoadCompleted;
                      });
                    });
                  }
                  if (widget.model.isPaginateLoading == false &&
                      !isLoadCompleted) {
                    Future(() {
                      widget.ref
                          .read(widget._videoProvider.notifier)
                          .loadMore();
                    });
                  }
                  return SizedBox.shrink();
                }
                VideoData data = widget.videoList[index];
                return VideoItem(data: data, colorScheme: widget.colorScheme);
              },
            ),
          ),
        ),
        if (_loadCompleted)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: widget.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                "All items loaded",
                style: TextStyle(
                  color: widget.colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        if (widget.model.isPaginateLoading)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: widget.colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
