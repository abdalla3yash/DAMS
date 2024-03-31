import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class videoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  videoPlayer({super.key, required this.controller});

  @override
  _videoPlayerState createState() => _videoPlayerState();
}

class _videoPlayerState extends State<videoPlayer> {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: widget.controller.value.isInitialized
            ? AspectRatio(aspectRatio: widget.controller.value.aspectRatio,child: VideoPlayer(widget.controller))
            : CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose the video controller
    widget.controller.dispose();
  }
}
