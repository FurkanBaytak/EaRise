import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main_page/seensound_home.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  User? _user;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      final userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          setState(() {
            _fullNameController.text = userData['fullName'] ?? '';
            _phoneNumberController.text = userData['phoneNumber'] ?? '';
          });
        }
      }
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_imageFile != null) {
        final storageRef = _storage.ref().child('user_images/${_user!.uid}.jpg');
        await storageRef.putFile(_imageFile!);
        final photoUrl = await storageRef.getDownloadURL();
        await _user!.updatePhotoURL(photoUrl);
      }

      await _firestore.collection('users').doc(_user!.uid).set({
        'fullName': _fullNameController.text,
        'phoneNumber': _phoneNumberController.text,
      }, SetOptions(merge: true));

      Get.snackbar('Başarılı', 'Profil bilgileri güncellendi.');
    } catch (e) {
      Get.snackbar('Hata', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _changePassword() async {
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();
    Get.defaultDialog(
      title: 'Şifre Değiştir',
      content: Column(
        children: [
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Yeni Şifre'),
            obscureText: true,
          ),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: 'Şifreyi Doğrula'),
            obscureText: true,
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          if (_passwordController.text == _confirmPasswordController.text) {
            try {
              await _user!.updatePassword(_passwordController.text);
              Get.back();
              Get.snackbar('Başarılı', 'Şifre güncellendi.');
            } catch (e) {
              Get.snackbar('Hata', e.toString());
            }
          } else {
            Get.snackbar('Hata', 'Şifreler eşleşmiyor.');
          }
        },
        child: Text('Güncelle'),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text('İptal'),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    Get.defaultDialog(
      title: 'Hesabı Sil',
      middleText: 'Hesabınızı silmek istediğinizden emin misiniz?',
      confirm: ElevatedButton(
        onPressed: () async {
          try {
            // Delete user data from Firestore
            await _firestore.collection('users').doc(_user!.uid).delete();
            // Delete user authentication
            await _user!.delete();
            Get.back();
            Get.snackbar('Başarılı', 'Hesap başarıyla silindi.');
            // Open the URL
            final Uri uri = Uri.parse('https://earisegencbizz.com.tr/delete_complete');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              throw 'Could not launch $uri';
            }
          } catch (e) {
            Get.snackbar('Hata', e.toString());
          }
        },
        child: Text('Evet'),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text('Hayır'),
      ),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    final Uri uri = Uri.parse('https://earisegencbizz.com.tr/privacy_policy/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Widget buildTextField(TextEditingController controller, String labelText, {bool enabled = true}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        enabled: enabled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Hesap Bilgilerim', style: TextStyle(color: Colors.black, fontSize: 20)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.white],
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
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (_user?.photoURL != null ? NetworkImage(_user!.photoURL!) : null) as ImageProvider<Object>?,
                      child: _imageFile == null && _user?.photoURL == null
                          ? Icon(Icons.camera_alt, size: 50)
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                buildTextField(_fullNameController, 'Ad Soyad'),
                SizedBox(height: 16),
                buildTextField(_phoneNumberController, 'Telefon Numarası'),
                SizedBox(height: 16),
                buildTextField(TextEditingController(text: _user?.email), 'E-posta', enabled: false),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: Text('Güncelle', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: Text('Şifre Değiştir', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _deleteAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: Text('Hesabı Sil', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _openPrivacyPolicy,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: Text('Gizlilik Politikası', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}