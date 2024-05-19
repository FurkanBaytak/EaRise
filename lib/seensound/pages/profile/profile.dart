import 'package:EaRise/seensound/pages/profile/button_pages/account.dart';
import 'package:EaRise/seensound/pages/profile/button_pages/notifications/notification_screen.dart';
import 'package:EaRise/seensound/pages/profile/signup.dart';
import 'package:EaRise/seensound/pages/profile/signin.dart';
import 'package:EaRise/seensound/pages/profile/users_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../main_page/seensound_theme.dart';
import 'button_pages/notifications/notification_controller.dart';
import 'button_pages/subscription.dart';

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
  User? _user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationController notificationController = Get.put(NotificationController());
  final UserController userController = Get.put(UserController());
  String _fullName = '';

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );

    addAllListData();
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      final userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          setState(() {
            _fullName = userData['fullName'] ?? '';
          });
        }
      }
    }
  }

  void addAllListData() {
    listViews.add(
      FutureBuilder(
        future: _loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox.shrink();
          }
          return _user != null && !_user!.isAnonymous
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoşgeldin,',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: SeenSoundTheme.darkerText,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _fullName,
                  style: TextStyle(
                    fontSize: 35,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: SeenSoundTheme.nearlyDarkBlue,
                  ),
                ),
              ],
            ),
          )
              : SizedBox.shrink();
        },
      ),
    );

    listViews.add(
      getAnimatedButton(
        icon: Icons.account_circle,
        text: 'Hesap Bilgilerim',
        animationIndex: 0,
        onPressed: () {
          if (_user?.isAnonymous ?? true) {
            Get.snackbar('Giriş Yap', 'Bu bölüme erişmek için giriş yapmanız gerekmektedir.');
          } else {
            Get.to(() => AccountScreen());
          }
        },
      ),
    );

    listViews.add(
      getAnimatedButton(
        icon: Icons.event_note,
        text: 'Planım',
        animationIndex: 1,
        onPressed: () {
          if (_user?.isAnonymous ?? true) {
            Get.snackbar('Giriş Yap', 'Bu bölüme erişmek için giriş yapmanız gerekmektedir.');
          } else {
            Get.to(() => Subscription());
          }
        },
      ),
    );

    listViews.add(
      getAnimatedButtonWithNotification(
        icon: Icons.notifications,
        text: 'Bildirimler',
        animationIndex: 2,
        onPressed: () {
          Get.to(() => NotificationsScreen());
        },
        hasUnreadNotifications: notificationController.hasUnreadNotifications,
      ),
    );

    if (!(_user?.isAnonymous ?? true)) {
      listViews.add(
        getAnimatedButton(
          icon: Icons.exit_to_app,
          text: 'Çıkış Yap',
          animationIndex: 3,
          onPressed: () async {
            await userController.logout();
            Get.offAll(() => SignInScreen());
          },
        ),
      );
    } else {
      listViews.add(
        getAnimatedButton(
          icon: Icons.login,
          text: 'Giriş Yap',
          animationIndex: 3,
          onPressed: () {
            Get.to(() => SignInScreen());
          },
        ),
      );

      listViews.add(
        getAnimatedButton(
          icon: Icons.app_registration,
          text: 'Kayıt Ol',
          animationIndex: 4,
          onPressed: () {
            Get.to(() => SignUpScreen());
          },
        ),
      );
    }
  }

  Widget getAnimatedButton({
    required IconData icon,
    required String text,
    required int animationIndex,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedBuilder(
        animation: widget.animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / 4) * animationIndex, 1.0, curve: Curves.easeInOut),
              ),
            ),
            child: Transform(
              transform: Matrix4.translationValues(
                  -MediaQuery.of(context).size.width * (1.0 - topBarAnimation!.value), 0.0, 0.0),
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
                  onTap: onPressed,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getAnimatedButtonWithNotification({
    required IconData icon,
    required String text,
    required int animationIndex,
    required VoidCallback onPressed,
    required RxBool hasUnreadNotifications,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedBuilder(
        animation: widget.animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / 4) * animationIndex, 1.0, curve: Curves.easeInOut),
              ),
            ),
            child: Transform(
              transform: Matrix4.translationValues(
                  -MediaQuery.of(context).size.width * (1.0 - topBarAnimation!.value), 0.0, 0.0),
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
                child: Stack(
                  children: [
                    ListTile(
                      leading: Icon(icon, color: SeenSoundTheme.nearlyDarkBlue, size: 30),
                      title: Text(
                        text,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: SeenSoundTheme.darkerText,
                        ),
                      ),
                      onTap: onPressed,
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Obx(() {
                        return hasUnreadNotifications.value
                            ? Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        )
                            : SizedBox.shrink();
                      }),
                    ),
                  ],
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
                      SizedBox(height: 10),
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
