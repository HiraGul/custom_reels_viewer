import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:reels_viewer/src/models/reel_model.dart';
import 'package:video_player/video_player.dart';

import 'components/screen_options.dart';
import 'components/video_service.dart';

class ReelsPage extends StatefulWidget {
  final ReelModel item;
  final bool showVerifiedTick;
  final Function(String)? onShare;
  final Function(String)? onLike;
  final Function(String)? onComment;
  final Function()? onClickMoreBtn;
  final Function()? onFollow;
  final SwiperController swiperController;
  final bool showProgressIndicator;

  const ReelsPage({
    Key? key,
    required this.item,
    this.showVerifiedTick = true,
    this.onClickMoreBtn,
    this.onComment,
    this.onFollow,
    this.onLike,
    this.onShare,
    this.showProgressIndicator = true,
    required this.swiperController,
  }) : super(key: key);

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  bool _isPlaying = true; // Track whether the video is playing

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    await VideoService().initialize(widget.item.url);
    setState(() {});

    VideoService().videoPlayerController.addListener(() {
      if (VideoService().videoPlayerController.value.position ==
          VideoService().videoPlayerController.value.duration) {
        widget.swiperController.next();
      }
    });
  }

  @override
  void dispose() {
    VideoService().dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        VideoService().chewieController?.pause();
      } else {
        VideoService().chewieController?.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return getVideoView();
  }

  Widget getVideoView() {
    return PopScope(
      onPopInvoked: (val) async {
        VideoService().dispose();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          VideoService().chewieController != null &&
                  VideoService()
                      .chewieController!
                      .videoPlayerController
                      .value
                      .isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: GestureDetector(
                      onTap: _togglePlayPause, // Toggle play/pause on tap
                      onDoubleTap: () {},
                      child: Chewie(
                        controller: VideoService().chewieController!,
                      ),
                    ),
                  ),
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ],
                ),
          if (widget.showProgressIndicator)
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: VideoProgressIndicator(
                VideoService().videoPlayerController,
                allowScrubbing: false,
                colors: const VideoProgressColors(
                  backgroundColor: Colors.black,
                  bufferedColor: Colors.black,
                  playedColor: Colors.blueAccent,
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: ScreenOptions(
              onClickMoreBtn: widget.onClickMoreBtn,
              onComment: widget.onComment,
              onFollow: widget.onFollow,
              onLike: widget.onLike,
              onShare: widget.onShare,
              showVerifiedTick: widget.showVerifiedTick,
              item: widget.item,
            ),
          )
        ],
      ),
    );
  }
}
