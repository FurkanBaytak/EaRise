import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  VideoPlayerController? _videoPlayerController;
  RxBool isPlaying = false.obs;
  RxBool showDefaultImage = true.obs;
  RxBool isButtonEnabled = true.obs;

  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  Future<void> playVideo(String path) async {
    _videoPlayerController?.dispose();
    _videoPlayerController = VideoPlayerController.asset(path);
    showDefaultImage.value = false;
    isButtonEnabled.value = false;
    update();

    await _videoPlayerController!.initialize();
    _videoPlayerController!.play();
    isPlaying.value = true;
    update();

    _videoPlayerController!.addListener(() {
      if (_videoPlayerController!.value.position == _videoPlayerController!.value.duration) {
        showDefaultImage.value = true;
        isPlaying.value = false;
        update();
      }
    });
  }

  void resetState() {
    showDefaultImage.value = true;
    isButtonEnabled.value = true;
    isPlaying.value = false;
    update();
  }

  @override
  void onClose() {
    _videoPlayerController?.dispose();
    super.onClose();
  }
}
