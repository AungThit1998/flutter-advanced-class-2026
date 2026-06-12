import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/audio/notifiers/audio_list/audio_notifier.dart';
import 'package:media_content_library_app/features/audio/notifiers/audio_list/audio_state_model.dart';
import '../../../../features/audio/ui/widgets/audio_item.dart';
import '../../../../features/audio/data/model/audio_model.dart';

class DesktopAudioList extends StatefulWidget {
  const DesktopAudioList({
    super.key,
    required this.audioList,
    required this.colorScheme,
    required this.ref,
    required AudioProvider audioProvider,
    required this.model,
  }) : _audioProvider = audioProvider;

  final List<AudioData> audioList;
  final ColorScheme colorScheme;
  final WidgetRef ref;
  final AudioProvider _audioProvider;
  final AudioStateModel model;

  @override
  State<DesktopAudioList> createState() => _DesktopAudioListState();
}

class _DesktopAudioListState extends State<DesktopAudioList> {
  final ScrollController _scrollController = ScrollController();
  bool _loadCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 350,
              mainAxisExtent: 300,
            ),
            itemCount: widget.audioList.length + 1,
            itemBuilder: (context, index) {
              if (index == widget.audioList.length) {
                bool isLoadCompleted = index == widget.model.audioModel?.total;
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
                    widget.ref.read(widget._audioProvider.notifier).loadMore();
                  });
                }
                return SizedBox.shrink();
              }
              AudioData data = widget.audioList[index];
              return AudioItem(data: data, colorScheme: widget.colorScheme);
            },
          ),
        ),
        if (_loadCompleted)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Load Completed"),
            ),
          ),
        if (widget.model.isPaginateLoading)
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
