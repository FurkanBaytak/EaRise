import 'package:EaRise/seensound/main_page/seensound_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../main_page/seensound_home.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _signUpWithEmail() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar('Hata', 'Şifreler eşleşmiyor.');
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Get.snackbar('Başarılı', 'Kayıt işlemi başarıyla tamamlandı.');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SeensoundHomeScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      Get.snackbar('Hata', e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Get.snackbar('Başarılı', 'Google ile giriş yapıldı.');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SeensoundHomeScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      Get.snackbar('Hata', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Kayıt Ol', style: TextStyle(color: SeenSoundTheme.darkText, fontSize: 20)),
        backgroundColor: SeenSoundTheme.white,
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
                    Icons.person_add,
                    size: 100,
                    color: SeenSoundTheme.nearlyDarkBlue,
                  ),
                ),
                SizedBox(height: 16),
                buildTextField(_emailController, 'E-posta'),
                SizedBox(height: 16),
                buildPasswordField(_passwordController, 'Şifre', _obscurePassword, () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                }),
                SizedBox(height: 16),
                buildPasswordField(_confirmPasswordController, 'Şifreyi Doğrula', _obscureConfirmPassword, () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                }),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _signUpWithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SeenSoundTheme.nearlyDarkBlue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: Text(
                      'Kayıt Ol',
                      style: TextStyle(fontSize: 18, color: SeenSoundTheme.white),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.account_circle, size: 50, color: Colors.red),
                    onPressed: _signInWithGoogle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText) {
    return Container(
      decoration: BoxDecoration(
        color: SeenSoundTheme.white,
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
      ),
    );
  }

  Widget buildPasswordField(TextEditingController controller, String labelText, bool obscureText, VoidCallback onToggle) {
    return Container(
      decoration: BoxDecoration(
        color: SeenSoundTheme.white,
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
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
