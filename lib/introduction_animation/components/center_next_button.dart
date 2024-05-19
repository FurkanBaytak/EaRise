import 'package:EaRise/seensound/pages/profile/signin.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import '../../seensound/pages/profile/signup.dart';

class CenterNextButton extends StatefulWidget {
  final AnimationController animationController;
  final VoidCallback onNextClick;
  final VoidCallback onStartClick;

  const CenterNextButton({
    Key? key,
    required this.animationController,
    required this.onNextClick,
    required this.onStartClick,
  }) : super(key: key);

  @override
  _CenterNextButtonState createState() => _CenterNextButtonState();
}

class _CenterNextButtonState extends State<CenterNextButton> with TickerProviderStateMixin {
  late AnimationController _startAppAnimationController;
  late Animation<Offset> _startAppAnimation;

  @override
  void initState() {
    super.initState();

    _startAppAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _startAppAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _startAppAnimationController,
      curve: Curves.easeInOut,
    ));

    widget.animationController.addListener(() {
      if (widget.animationController.value > 0.7) {
        _startAppAnimationController.forward();
      } else {
        _startAppAnimationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _startAppAnimationController.dispose();
    super.dispose();
  }

  //Page route to the sign up screen
  void _onStartClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _topMoveAnimation = Tween<Offset>(begin: Offset(0, 5), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final _signUpMoveAnimation = Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final _loginTextMoveAnimation = Tween<Offset>(begin: Offset(0, 5), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    return Padding(
      padding: EdgeInsets.only(bottom: 16 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SlideTransition(
            position: _topMoveAnimation,
            child: AnimatedBuilder(
              animation: widget.animationController,
              builder: (context, child) => Padding(
                padding: EdgeInsets.only(bottom: 38 - (38 * _signUpMoveAnimation.value)),
                child: Column(
                  children: [
                    // 'Uygulamaya Başla' butonu
                    SlideTransition(
                      position: _startAppAnimation,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0), // Butonun başlangıç konumunu biraz aşağıda ayarlamak için padding ekledik
                        child: Container(
                          height: 68, // Boyutunu biraz büyüttük
                          width: 68 + (220 * _signUpMoveAnimation.value), // Genişliğini biraz büyüttük
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8 + 32 * (1 - _signUpMoveAnimation.value)),
                            color: Color(0xFFAB896D),
                          ),
                          child: PageTransitionSwitcher(
                            duration: Duration(milliseconds: 480),
                            reverse: _signUpMoveAnimation.value < 0.7,
                            transitionBuilder: (
                                Widget child,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                ) {
                              return SharedAxisTransition(
                                fillColor: Colors.transparent,
                                child: child,
                                animation: animation,
                                secondaryAnimation: secondaryAnimation,
                                transitionType: SharedAxisTransitionType.vertical,
                              );
                            },
                            child: _signUpMoveAnimation.value > 0.7
                                ? InkWell(
                              key: ValueKey('Start App button'),
                              onTap: _onStartClick,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0), // Padding değerlerini ayarladık
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Hemen Dene',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20, // Font boyutunu artırdık
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_rounded, color: Colors.white),
                                  ],
                                ),
                              ),
                            )
                                : SizedBox(),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24), // "Kayıt Ol" düğmesi ile aradaki boşluk artırıldı

                    // 'Kayıt Ol' butonu
                    Container(
                      height: 58,
                      width: 58 + (200 * _signUpMoveAnimation.value),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8 + 32 * (1 - _signUpMoveAnimation.value)),
                        color: Color(0xFF567488), // "Kayıt Ol" düğmesinin rengi
                      ),
                      child: PageTransitionSwitcher(
                        duration: Duration(milliseconds: 480),
                        reverse: _signUpMoveAnimation.value < 0.7,
                        transitionBuilder: (
                            Widget child,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            ) {
                          return SharedAxisTransition(
                            fillColor: Colors.transparent,
                            child: child,
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.vertical,
                          );
                        },
                        child: _signUpMoveAnimation.value > 0.7
                            ? InkWell(
                          key: ValueKey('Sign Up button'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen()),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Kayıt Ol',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_rounded, color: Colors.white),
                              ],
                            ),
                          ),
                        )
                            : InkWell(
                          key: ValueKey('next button'),
                          onTap: widget.onNextClick,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    if (widget.animationController.value < 0.7)
                      _pageView(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SlideTransition(
              position: _loginTextMoveAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageView() {
    int _selectedIndex = 0;

    if (widget.animationController.value >= 0.5) {
      _selectedIndex = 2;
    } else if (widget.animationController.value >= 0.3) {
      _selectedIndex = 1;
    } else if (widget.animationController.value >= 0.1) {
      _selectedIndex = 0;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.all(4),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 480),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: _selectedIndex == i ? Color(0xff132137) : Color(0xffE3E4E4),
                ),
                width: 10,
                height: 10,
              ),
            )
        ],
      ),
    );
  }
}
