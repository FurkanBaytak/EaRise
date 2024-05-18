import 'package:EaRise/seensound/main_page/seensound_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  Future<void> sendEmail() async {
    final Email email = Email(
      body: 'Ad: ${nameController.text}\nSoyad: ${surnameController.text}\nEmail: ${emailController.text}\nBildirim: ${feedbackController.text}',
      subject: 'Geri Bildirim ${DateTime.now()}',
      recipients: ['earisegencbizz@gmail.com'],
    );

    try {
      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Geri bildiriminiz başarıyla gönderildi.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Geri bildiriminiz gönderilemedi: $error')),
      );
    }
    // Gönderilmek istenen bilgileri konsola yaz
    print('Ad: ${nameController.text}');
    print('Soyad: ${surnameController.text}');
    print('Email: ${emailController.text}');
    print('Bildirim: ${feedbackController.text}');

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
        title: Text('Şikayet ve Geri Bildirim', style: TextStyle(color: SeenSoundTheme.darkText, fontSize: 20)),
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
                  child: Image.asset(
                    'assets/images/feedbackImage.png',
                    height: 200,
                    width: 200,
                  ),
                ),
                SizedBox(height: 16),
                buildTextField(nameController, 'Ad'),
                SizedBox(height: 16),
                buildTextField(surnameController, 'Soyad'),
                SizedBox(height: 16),
                buildTextField(emailController, 'Mail'),
                SizedBox(height: 16),
                buildTextField(feedbackController, 'Bildirim', maxLines: 5),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: sendEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SeenSoundTheme.nearlyDarkBlue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: Text(
                      'Gönder',
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

  Widget buildTextField(TextEditingController controller, String labelText, {int maxLines = 1}) {
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
        maxLines: maxLines,
      ),
    );
  }
}
