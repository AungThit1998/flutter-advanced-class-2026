import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MyYoutubeVideoPlayer extends StatefulWidget {
  const MyYoutubeVideoPlayer({super.key, required this.url});

  final String url;

  @override
  State<MyYoutubeVideoPlayer> createState() => _MyYoutubeVideoPlayerState();
}

class _MyYoutubeVideoPlayerState extends State<MyYoutubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url)!,
      flags: YoutubePlayerFlags(autoPlay: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      progressColors: const ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
      onReady: () {

      },
    );
  }
}
