import 'package:flutter/material.dart';
import '../../main_page/seensound_theme.dart';

class Hesabim extends StatefulWidget {
  const Hesabim({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _HesabimState createState() => _HesabimState();
}

class _HesabimState extends State<Hesabim> with TickerProviderStateMixin {
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
        icon: Icons.account_circle,
        text: 'Hesap Bilgilerim',
        animationIndex: 0,
      ),
    );

    listViews.add(
      getAnimatedButton(
        icon: Icons.event_note,
        text: 'Planım',
        animationIndex: 1,
      ),
    );

    listViews.add(
      getAnimatedButton(
        icon: Icons.notifications,
        text: 'Bildirimler',
        animationIndex: 2,
      ),
    );

    listViews.add(
      getAnimatedButton(
        icon: Icons.exit_to_app,
        text: 'Çıkış Yap',
        animationIndex: 3,
      ),
    );
  }

  Widget getAnimatedButton({required IconData icon, required String text, required int animationIndex}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedBuilder(
        animation: widget.animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / 4) * animationIndex, 1.0, curve: Curves.easeInOut), // Daha yavaş ve akıcı
              ),
            ),
            child: Transform(
              transform: Matrix4.translationValues(
                  -MediaQuery.of(context).size.width * (1.0 - topBarAnimation!.value), 0.0, 0.0), // Ekranın en sağından başlıyor
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
                              height: 200,
                              width: 200,
                              child: Center(
                                child: Image.asset(
                                  'assets/introduction_animation/seensound_icon.png',
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
