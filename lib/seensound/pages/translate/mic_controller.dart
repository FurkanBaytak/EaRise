import 'package:get/get.dart';

class MicController extends GetxController {
  var isListening = false.obs;

  void toggleListening() {
    isListening.value = !isListening.value;
  }
}
