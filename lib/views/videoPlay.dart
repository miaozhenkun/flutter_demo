import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class videoPlayPage extends StatefulWidget {
  var videoUrl;
  videoPlayPage({Key key, @required this.videoUrl}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    videoUrl = this.videoUrl;
    print(videoUrl);
    return new videoState(videoUrl);
  }
}

class videoState  extends State{
  var videoUrl;
  videoState(this.videoUrl);
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
    );;
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
