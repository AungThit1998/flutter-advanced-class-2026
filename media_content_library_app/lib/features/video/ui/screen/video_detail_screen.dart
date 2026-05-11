import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/const/widgets/common/try_again_widget.dart';
import 'package:media_content_library_app/features/video/data/models/video_model.dart';
import 'package:media_content_library_app/features/video/notifiers/video_detail/video_detail_state_model.dart';
import 'package:media_content_library_app/features/video/ui/widgets/direct_video_player.dart';
import 'package:media_content_library_app/features/video/ui/widgets/my_youtube_video_player.dart';
import 'package:media_content_library_app/features/video/ui/widgets/my_youtube_video_player_web.dart';

import '../../notifiers/video_detail/video_detail_notifier.dart';

class VideoDetailScreen extends ConsumerStatefulWidget {
  const VideoDetailScreen({super.key, required this.id});
  final String? id;

  @override
  ConsumerState<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends ConsumerState<VideoDetailScreen> {
  final VideoDetailProvider _provider = VideoDetailProvider(() => VideoDetailNotifier());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(_provider.notifier).geVideo(widget.id);
    });
  }
  @override
  Widget build(BuildContext context) {
    VideoDetailStateModel stateModel = ref.watch(_provider);
    return Scaffold(
      appBar: AppBar(
        title: Text(stateModel.videoData?.title ?? "......"),
      ),
      body: _videoDetailBody(),
    );
  }
  Widget _videoDetailBody(){
    VideoDetailStateModel stateModel = ref.watch(_provider);
    if(stateModel.isLoading){
      return Center(child: CircularProgressIndicator());
    }
    else if(stateModel.isError){
      return TryAgainWidget(onTryAgain: (){
        ref.read(_provider.notifier).geVideo(widget.id);
      });
    }
    VideoData? videoData = stateModel.videoData;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500
        ),
        child: Column(
          children: [
            Text(videoData?.description ?? ""),
            if(videoData?.source == "direct" && videoData?.url != null)
              DirectVideoPlayer(link: videoData!.url!),
            if(videoData?.source == "youtube" && videoData?.url != null)
              if(kIsWeb)
                MyYoutubeVideoPlayerWeb(url: videoData!.url!),
              if(!kIsWeb)
              MyYoutubeVideoPlayer(url: videoData!.url!),
        ],),
      ),
    );
  }
}
