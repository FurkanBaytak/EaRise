import 'package:EaRise/introduction_animation/introduction_animation_screen.dart';
import 'package:flutter/widgets.dart';
import '../seensound/main_page/seensound_home.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png',
      navigateScreen: IntroductionAnimationScreen(),
    ),
    HomeList(
      imagePath: 'assets/fitness_app/fitness_app.png',
      navigateScreen: SeensoundHomeScreen(),
    ),
  ];
}
