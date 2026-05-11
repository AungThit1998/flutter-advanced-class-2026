import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MyYoutubeVideoPlayerWeb extends StatefulWidget {
  const MyYoutubeVideoPlayerWeb({super.key, required this.url});

  final String url;

  @override
  State<MyYoutubeVideoPlayerWeb> createState() =>
      _MyYoutubeVideoPlayerWebState();
}

class _MyYoutubeVideoPlayerWebState extends State<MyYoutubeVideoPlayerWeb> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(widget.url)!,
      autoPlay: true,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(controller: _controller, aspectRatio: 16 / 9);
  }
}
