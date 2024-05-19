import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { anonymous, loggedIn, premium }

class UserController extends GetxController {
  final GetStorage storage = GetStorage();
  final playCount = 0.obs;
  UserType userType = UserType.anonymous;
  final maxPlaysForAnonymous = 3;
  final maxPlaysForLoggedIn = 10;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    playCount.value = storage.read('playCount') ?? 0;
    _fetchUserType();
  }

  Future<void> _fetchUserType() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userTypeString = userDoc.data()?['userType'] ?? 'anonymous';
        userType = UserType.values.firstWhere((e) => e.toString() == 'UserType.$userTypeString');
      } else {
        userType = UserType.anonymous;
      }
    } else {
      userType = UserType.anonymous;
    }
    storage.write('userType', userType.index);
  }

  void incrementPlayCount() {
    playCount.value++;
    storage.write('playCount', playCount.value);
  }

  bool canPlay() {
    switch (userType) {
      case UserType.anonymous:
        return playCount.value < maxPlaysForAnonymous;
      case UserType.loggedIn:
        return playCount.value < maxPlaysForLoggedIn;
      case UserType.premium:
        return true;
      default:
        return false;
    }
  }

  void resetPlayCount() {
    playCount.value = 0;
    storage.write('playCount', playCount.value);
  }

  Future<void> setUserType(UserType type) async {
    userType = type;
    storage.write('userType', type.index);

    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({'userType': type.toString().split('.').last}, SetOptions(merge: true));
    }
  }

  Future<void> logout() async {
    userType = UserType.anonymous;
    storage.write('userType', userType.index);
    await _auth.signOut();
  }
}
