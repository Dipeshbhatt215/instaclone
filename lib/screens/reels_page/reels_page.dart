import 'package:chewie/chewie.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages

import 'package:instaclone/screens/reels_page/widgetcompo.dart';
import 'package:video_player/video_player.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({Key? key}) : super(key: key);

  @override
  _ReelsPageState createState() => _ReelsPageState();
}

final videoPlayerController = VideoPlayerController.network(
    'https://player.vimeo.com/external/420239207.sd.mp4?s=2b5a6633c37af1a6fb0beb02c06bdc376fdfcce2&profile_id=165&oauth2_token_id=57447761');

class _ReelsPageState extends State<ReelsPage> {
  @override
  void initState() {
    loadVideoClip();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Positioned buildPosLikeComment() {
      return Positioned(
          bottom: 30,
          right: 10,
          width: 50,
          height: 100,
          child: likeShareCommentSave());
    }

    return Scaffold(
      body: Stack(
        children: [
          Chewie(controller: chewie), // Video Player
          CommentWithPublisher(),
          buildPosLikeComment()
        ],
      ),
    );
  }

  void loadVideoClip() async {
    await videoPlayerController.initialize();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewie.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  final chewie = ChewieController(
    videoPlayerController: videoPlayerController,
    autoPlay: true,
    looping: true,
    allowFullScreen: true,
    autoInitialize: true,
    cupertinoProgressColors: ChewieProgressColors(),
  );
}
