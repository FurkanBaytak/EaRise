import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EaRise/seensound/main_page/seensound_theme.dart';
import '../users_controller.dart';

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  User? _user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _fullName = '';
  UserType _userType = UserType.anonymous;
  final UserController _userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      final userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          setState(() {
            _fullName = userData['fullName'] ?? '';
            _userType = UserType.values.firstWhere(
                    (e) => e.toString() == 'UserType.${userData['userType']}',
                orElse: () => UserType.anonymous);
          });
        }
      }
    }
  }

  void _upgradeToPremium() async {
    if (_user != null) {
      await _firestore.collection('users').doc(_user!.uid).update({'userType': 'premium'});
      _userController.setUserType(UserType.premium);
      setState(() {
        _userType = UserType.premium;
      });
    }
    Get.snackbar('Premium Üyelik', 'Premium üyelik satın alma sayfasına yönlendirileceksiniz.');
  }

  void _downgradeToTrial() async {
    if (_user != null) {
      await _firestore.collection('users').doc(_user!.uid).update({'userType': 'loggedIn'});
      _userController.setUserType(UserType.loggedIn);
      setState(() {
        _userType = UserType.loggedIn;
      });
    }
    Get.snackbar('Deneme Sürümü', 'Deneme sürümüne geri döndünüz.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Planım', style: TextStyle(color: SeenSoundTheme.darkText, fontSize: 20)),
        backgroundColor: SeenSoundTheme.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [SeenSoundTheme.background, SeenSoundTheme.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color: SeenSoundTheme.nearlyDarkBlue,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    _fullName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: SeenSoundTheme.darkerText,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                buildPlanButton('Deneme Sürümü', _userType == UserType.loggedIn, onPressed: _downgradeToTrial),
                SizedBox(height: 16),
                buildPlanButton('Premium Üyelik', _userType == UserType.premium, onPressed: _upgradeToPremium),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPlanButton(String label, bool isActive, {VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? SeenSoundTheme.nearlyDarkBlue : SeenSoundTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: isActive ? SeenSoundTheme.white : SeenSoundTheme.nearlyDarkBlue,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isActive
            ? Icon(
          Icons.check_circle,
          color: SeenSoundTheme.white,
        )
            : null,
        onTap: isActive ? null : onPressed,
      ),
    );
  }
}
