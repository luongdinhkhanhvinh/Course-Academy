import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class VideoPlayerWidgetAlt extends StatefulWidget {
  final String videoUrl;
  final UniqueKey newKey;
  VideoPlayerWidgetAlt({@required this.videoUrl, this.newKey})
      : super(key: newKey);
  @override
  _VideoPlayerWidgetAltState createState() => _VideoPlayerWidgetAltState();
}

class _VideoPlayerWidgetAltState extends State<VideoPlayerWidgetAlt> {
  // String videoURLTemp =
  //     "http://192.168.31.118/AcademyWeb/uploads/lesson_files/videos/8eafef080f4befb0de2c8bdeb8a80768.mp4";

  VideoPlayerController _controller;
  // ignore: unused_field
  Future<void> _initializeVideoPlayerFuture;
  FlickManager flickManager;

  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl);
    // _initializeVideoPlayerFuture = _controller.initialize();
    flickManager = FlickManager(videoPlayerController: _controller);
    // _controller.setLooping(true);
    // _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Align(
          alignment: Alignment.center,
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: FlickVideoPlayer(flickManager: flickManager)),
        ),
      ),
    );
  }
}
