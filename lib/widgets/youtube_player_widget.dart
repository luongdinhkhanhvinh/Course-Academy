import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;
  final UniqueKey newKey;
  YoutubePlayerWidget({@required this.videoUrl, this.newKey});
  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  // String videoURL = "https://www.youtube.com/watch?v=n8X9_MgEdCg";

  YoutubePlayerController _controller;

  void initState() {
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: Align(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fill,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
