import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:EaRise/seensound/main_page/seensound_theme.dart';

class SocialAccounts extends StatelessWidget {
  const SocialAccounts({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Sosyal Medya Hesaplarımız', style: TextStyle(color: SeenSoundTheme.darkText, fontSize: 20)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/images/social_media.png',
                  height: 350,
                  width: 350,
                ),
              ),
              SizedBox(height: 24),
              buildSocialMediaButton(
                context,
                icon: FontAwesomeIcons.instagram,
                text: 'Instagram',
                url: 'https://www.instagram.com/earise_gencbizz?igsh=YWhmdnljZGU3cG5h',
              ),
              SizedBox(height: 16),
              buildSocialMediaButton(
                context,
                icon: FontAwesomeIcons.x,
                text: 'X',
                url: 'https://x.com/eaRiseGencbizz',
              ),
              SizedBox(height: 16),
              buildSocialMediaButton(
                context,
                icon: FontAwesomeIcons.facebook,
                text: 'Facebook',
                url: 'https://www.facebook.com/earisegencbizz',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSocialMediaButton(BuildContext context, {required IconData icon, required String text, required String url}) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Container(
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
    );
  }
}
