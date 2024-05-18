import 'package:EaRise/seensound/pages/about_earise/button_pages/feedback_screen.dart';
import 'package:EaRise/introduction_animation/introduction_animation_screen.dart';
import 'package:EaRise/seensound/pages/about_earise/button_pages/invite_friend_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main_page/seensound_theme.dart';
import 'button_pages/help.dart';
import 'button_pages/social_accounts.dart';

class EaRiseHakkinda extends StatefulWidget {
  const EaRiseHakkinda({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _EaRiseHakkindaState createState() => _EaRiseHakkindaState();
}

class _EaRiseHakkindaState extends State<EaRiseHakkinda> with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  Animation<double>? topBarAnimation;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 1.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );

    addAllListData();
    super.initState();
  }

  void addAllListData() {

    listViews.add(
      getAnimatedButton(
        icon: Icons.group,
        text: 'Sosyal Medyalarımız',
        animationIndex: 1,
        onPressed: () {
          Get.to(() => SocialAccounts());
        },
      ),
    );

    listViews.add(
      getAnimatedButton(
        icon: Icons.info,
        text: 'EaRise Hakkında',
        animationIndex: 2,
        onPressed: () {
          Get.to(() => IntroductionAnimationScreen());
        },
      ),
    );

    listViews.add(
      getAnimatedButton(
        icon: Icons.feedback,
        text: 'Şikayet ve Geri Bildirim',
        animationIndex: 3,
        onPressed: () {
          Get.to(() => FeedbackScreen());
        },
      ),
    );

    // Arkadaşlarını Davet Et butonu
    listViews.add(
      getAnimatedButton(
        icon: Icons.person_add,
        text: 'Arkadaşlarını Davet Et',
        animationIndex: 4,
        onPressed: () {
          Get.to(() => InviteFriend());
        },
      ),
    );

    listViews.add(
      getAnimatedButton(
        icon: Icons.help,
        text: 'Yardım',
        animationIndex: 4,
        onPressed: () {
          Get.to(() => HelpScreen());
        },
      ),
    );
  }

  Widget getAnimatedButton({required IconData icon, required String text, required int animationIndex, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedBuilder(
        animation: widget.animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / 5) * animationIndex, 1.0, curve: Curves.easeInOut), // Daha yavaş ve akıcı
              ),
            ),
            child: Transform(
              transform: Matrix4.translationValues(
                  MediaQuery.of(context).size.width * (1.0 - topBarAnimation!.value), 0.0, 0.0), // Ekranın en solundan başlıyor
              child: Container(
                decoration: BoxDecoration(
                  color: SeenSoundTheme.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: SeenSoundTheme.grey.withOpacity(0.4),
                      offset: Offset(2, 2),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(icon, color: SeenSoundTheme.nearlyDarkBlue, size: 30),
                  title: Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: SeenSoundTheme.darkerText,
                    ),
                  ),
                  onTap: onPressed, // Butonun onPressed işlevi burada
                ),
              ),
            ),
          );
        },
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
                  190,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
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
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
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
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 200, // Logonun boyutu artırıldı
                              width: 200,  // Logonun boyutu artırıldı
                              child: Center(
                                child: Image.asset(
                                  'assets/introduction_animation/earise_logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10), // Altına boşluk eklendi
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
