import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoService {
  static final VideoService _instance = VideoService._internal();
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  factory VideoService() {
    return _instance;
  }

  VideoService._internal();

  Future<void> initialize(String url) async {
    videoPlayerController = VideoPlayerController.network(url);
    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: false,
    );
  }

  void dispose() {
    chewieController?.dispose();
    videoPlayerController.dispose();
  }
}
