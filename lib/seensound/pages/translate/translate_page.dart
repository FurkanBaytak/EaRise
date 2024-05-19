import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:EaRise/seensound/main_page/seensound_theme.dart';
import '../../../main.dart';
import '../profile/users_controller.dart';
import 'video_controller.dart';
import 'mic_controller.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  AnimationController? micAnimationController;
  Animation<Offset>? micOffsetAnimation;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 1.0;

  final TextEditingController textEditingController = TextEditingController();
  final stt.SpeechToText speech = stt.SpeechToText();
  final VideoController videoController = Get.put(VideoController());
  final MicController micController = Get.put(MicController());
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    micAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    micOffsetAnimation = Tween<Offset>(
      begin: Offset(0, 2),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: micAnimationController!,
      curve: Curves.easeInOut,
    ));

    micAnimationController!.forward();

    addAllListData();
  }

  @override
  void dispose() {
    micAnimationController?.dispose();
    super.dispose();
  }

  void _performMicFunction() async {
    bool available = await speech.initialize(
      onStatus: (val) {
        print('onStatus: $val');
        micController.isListening.value = speech.isListening;
        if (!speech.isListening) {
          micController.stopTimer();
        }
      },
      onError: (val) {
        print('onError: $val');
        micController.isListening.value = false;
        micController.stopTimer();
      },
    );

    if (available) {
      if (speech.isListening) {
        speech.stop();
        print('Speech recognition is stopped');
        micController.isListening.value = false;
        micController.stopTimer();
      } else {
        speech.listen(
          onResult: (val) {
            print('onResult: ${val.recognizedWords}');
            updateText(val.recognizedWords);
          },
          localeId: 'tr_TR',
        );
        print('Speech recognition is started');
        micController.isListening.value = true;
        micController.startTimer();
      }
    } else {
      print("The user has denied the use of speech recognition.");
      micController.isListening.value = false;
      micController.stopTimer();
    }
  }

  void updateText(String text) {
    textEditingController.text = text;
    textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
  }

  void _onPlayButtonPressed() async {
    if (!userController.canPlay()) {
      Get.snackbar(
        'Limit Aşıldı',
        'Belirlenen sınırı aştınız. Lütfen daha sonra tekrar deneyiniz.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    userController.incrementPlayCount();

    String text = textEditingController.text.toLowerCase();
    text = text.replaceAll('ş', 's');
    text = text.replaceAll('ı', 'i');
    text = text.replaceAll('ç', 'c');
    text = text.replaceAll('ö', 'o');
    text = text.replaceAll('ü', 'u');
    text = text.replaceAll('ğ', 'g');
    List<String> words = text.split(' ');

    await _playVideoSequence(words);
  }

  Future<void> _playVideoSequence(List<String> words) async {
    int maxWords = 2;
    for (int i = 0; i < words.length; i++) {
      for (int j = maxWords; j > 0; j--) {
        if (i + j <= words.length) {
          String phrase = words.sublist(i, i + j).join('_');
          String videoPath = 'videos/$phrase.mp4';
          bool videoExists = await _videoExists(videoPath);

          if (videoExists) {
            print("Playing video: $videoPath");
            await videoController.playVideo(videoPath);
            await Future.delayed(Duration(milliseconds: videoController.videoPlayerController!.value.duration.inMilliseconds));
            videoController.resetState();
            i += (j - 1);
            break;
          }
        }
      }
    }
    videoController.resetState();
    videoController.update();
  }

  Future<bool> _videoExists(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.getDownloadURL();
      return true;
    } catch (e) {
      return false;
    }
  }

  void addAllListData() {
    const int count = 4;

    listViews.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / count) * 0, 1.0,
                          curve: Curves.fastOutSlowIn))),
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFBCBBBD),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: GetBuilder<VideoController>(
                        builder: (_) {
                          if (_.showDefaultImage.value) {
                            return Image.asset(
                              'assets/images/default.png',
                              fit: BoxFit.cover,
                            );
                          } else if (_.videoPlayerController != null && _.videoPlayerController!.value.isInitialized) {
                            return AspectRatio(
                              aspectRatio: _.videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(_.videoPlayerController!),
                            );
                          } else {
                            return Image.asset(
                              'assets/images/default.png',
                              fit: BoxFit.cover,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    listViews.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / count) * 1, 1.0,
                          curve: Curves.fastOutSlowIn))),
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    color: SeenSoundTheme.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: SeenSoundTheme.grey.withOpacity(0.4),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GetBuilder<VideoController>(
                              builder: (_) {
                                return InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: textEditingController.text));
                                    Get.snackbar('Kopyalandı', 'Metin kopyalandı');
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: SeenSoundTheme.nearlyDarkBlue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.copy,
                                      color: SeenSoundTheme.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            GetBuilder<VideoController>(
                              builder: (_) {
                                return InkWell(
                                  onTap: textEditingController.clear,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: SeenSoundTheme.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Çevirmek istediğiniz metni girin ya da söyleyiniz.',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: SeenSoundTheme.grey,
                              ),
                            ),
                            controller: textEditingController,
                            style: TextStyle(
                              fontSize: 14,
                              color: SeenSoundTheme.darkerText,
                            ),
                            maxLines: null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GetBuilder<VideoController>(
                          builder: (_) {
                            return InkWell(
                              onTap: _.isButtonEnabled.value ? _onPlayButtonPressed : null,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _.isButtonEnabled.value
                                      ? SeenSoundTheme.nearlyDarkBlue
                                      : SeenSoundTheme.grey.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  videoController.isPlaying.value
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: SeenSoundTheme.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    listViews.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))),
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Column(
                  children: [
                    Obx(() => Text(
                      'Süre: ${micController.elapsedTime.value} saniye',
                      style: TextStyle(fontSize: 16, color: SeenSoundTheme.nearlyDarkBlue),
                    )),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    listViews.add(
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SlideTransition(
            position: micOffsetAnimation!,
            child: InkWell(
              onTap: _performMicFunction,
              child: GetX<MicController>(
                builder: (controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: controller.isListening.value ? Colors.red : SeenSoundTheme.nearlyDarkBlue,
                      gradient: controller.isListening.value ? null : LinearGradient(
                          colors: [
                            SeenSoundTheme.nearlyDarkBlue,
                            HexColor('#6A88E5'),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: SeenSoundTheme.nearlyDarkBlue.withOpacity(0.4),
                            offset: const Offset(8.0, 16.0),
                            blurRadius: 16.0),
                      ],
                    ),
                    child: Icon(
                      controller.isListening.value ? Icons.mic_off : Icons.mic,
                      color: SeenSoundTheme.white,
                      size: 32,
                    ),
                    padding: EdgeInsets.all(16.0),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SeenSoundTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  16, // Üstteki padding'i azaltıyoruz
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return Container(
              decoration: BoxDecoration(
                color: SeenSoundTheme.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: SeenSoundTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // AppBar'ın padding değerini azalttık
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            SeenSoundTheme.nearlyDarkBlue,
                            HexColor('#6A88E5'),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/turkish_flag.png',
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'TÜRKÇE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.swap_horiz,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'İŞARET DİLİ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Image.asset(
                              'assets/icons/sign_language_icon.png',
                              height: 24,
                              width: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
