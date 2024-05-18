import 'package:EaRise/seensound/bottom_navigation_view/tabIcon_data.dart';
import 'package:EaRise/seensound/pages/about_earise/about_earise.dart';
import 'package:EaRise/seensound/pages/translate/translate_page.dart';
import 'package:flutter/material.dart';
import '../bottom_navigation_view/bottom_bar_view.dart';
import '../pages/profile/profile.dart';
import 'seensound_theme.dart';

class SeensoundHomeScreen extends StatefulWidget {
  @override
  _SeensoundHomeScreenState createState() => _SeensoundHomeScreenState();
}

class _SeensoundHomeScreenState extends State<SeensoundHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  bool isNewScreen = false;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: SeenSoundTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[2].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = TranslatePage(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SeenSoundTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            animationController?.reverse().then<dynamic>((data) {
              if (!mounted) {
                return;
              }
              setState(() {
                isNewScreen = true;
                tabBody = TranslatePage(animationController: animationController);
              });
            });
          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  isNewScreen = false;
                  tabBody =
                      EaRiseHakkinda(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  isNewScreen = false;
                  tabBody =
                      Hesabim(animationController: animationController);
                });
              });
            }
          },
          isNewScreen: isNewScreen, // Eklendi
        ),
      ],
    );
  }
}