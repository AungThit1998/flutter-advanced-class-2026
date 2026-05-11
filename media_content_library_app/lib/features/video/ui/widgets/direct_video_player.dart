import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DirectVideoPlayer extends StatefulWidget {
  const DirectVideoPlayer({super.key, required this.link});

  final String link;

  @override
  State<DirectVideoPlayer> createState() => _DirectVideoPlayerState();
}

class _DirectVideoPlayerState extends State<DirectVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.link));
    _controller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Column(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              SizedBox(height: 8),
              ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, value, child) {
                  double totalSecond = value.duration.inSeconds.toDouble();
                  double currentSecond = value.position.inSeconds.toDouble();
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(currentSecond)),
                          Text(_formatDuration(totalSecond)),
                        ],),
                      Slider(
                        value: currentSecond,
                        max: totalSecond,
                        onChanged: totalSecond > 0
                            ? (newValue) {
                                _controller.seekTo(
                                  Duration(seconds: newValue.toInt()),
                                );
                              }
                            : null,
                      ),
                    ],
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ],
          )
        : Container(
            alignment: Alignment.center,
            height: 300,
            child: CircularProgressIndicator(),
          );
  }
  String _formatDuration(double seconds){
   Duration duration = Duration(seconds: seconds.toInt());
   int hour = duration.inHours;
   String minute = duration.inMinutes.remainder(60).toString().padLeft(2,'0');
   String second = duration.inSeconds.remainder(60).toString().padLeft(2,'0');
   if(hour >0) return "$hour:$minute:$second";
   return "$minute:$second";
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
