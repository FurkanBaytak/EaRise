import 'package:EaRise/seensound/main_page/seensound_theme.dart';
import 'package:EaRise/seensound/pages/profile/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../main_page/seensound_home.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _signInWithEmail() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Get.snackbar('Başarılı', 'Giriş işlemi başarıyla tamamlandı.');
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

  Future<void> _signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
      Get.snackbar('Başarılı', 'Anonim olarak giriş yapıldı.');
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
        title: Text('Giriş Yap', style: TextStyle(color: SeenSoundTheme.darkText, fontSize: 20)),
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
                    Icons.lock_open,
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
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _signInWithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SeenSoundTheme.nearlyDarkBlue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: Text(
                      'Giriş Yap',
                      style: TextStyle(fontSize: 18, color: SeenSoundTheme.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hesabın yok mu?', style: TextStyle(fontSize: 16)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text(
                        'Hemen Kayıt Ol',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.account_circle, size: 50, color: Colors.red),
                    onPressed: _signInWithGoogle,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _signInAnonymously,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: Text(
                      'Anonim Olarak Giriş Yap',
                      style: TextStyle(fontSize: 18, color: SeenSoundTheme.white),
                    ),
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
