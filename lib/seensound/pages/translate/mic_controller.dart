import 'dart:async';
import 'package:get/get.dart';

class MicController extends GetxController {
  var isListening = false.obs;
  var elapsedTime = 0.obs;
  Timer? _timer;

  void toggleListening() {
    isListening.value = !isListening.value;
    if (isListening.value) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  void startTimer() {
    _timer?.cancel();
    elapsedTime.value = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedTime.value++;
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetElapsedTime() {
    elapsedTime.value = 0;
  }
}
