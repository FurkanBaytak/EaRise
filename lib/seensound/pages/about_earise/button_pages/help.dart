import 'package:flutter/material.dart';
import 'package:EaRise/seensound/main_page/seensound_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

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
        title: Text('Yardım', style: TextStyle(color: SeenSoundTheme.darkText, fontSize: 20)),
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
                    Icons.help_outline,
                    size: 100, // İkon boyutu burada ayarlanabilir
                    color: SeenSoundTheme.nearlyDarkBlue,
                  ),
                ),
                SizedBox(height: 24),
                buildHelpItem(
                  context,
                  number: '1',
                  title: 'Uygulamanın Başlatılması',
                  description: 'Uygulamayı açtığınızda, sizi ortada bir mikrofon tuşu karşılayacaktır. Bu tuşa basarak konuşabilirsiniz.',
                ),
                SizedBox(height: 16),
                buildHelpItem(
                  context,
                  number: '2',
                  title: 'Metin Düzenleme',
                  description: 'Mikrofon tuşuna bastığınızda söylediğiniz cümleler metin alanında görünecektir. Bu metin alanına tıklayarak metni düzenleyebilir veya doğrudan metin yazabilirsiniz.',
                ),
                SizedBox(height: 16),
                buildHelpItem(
                  context,
                  number: '3',
                  title: 'İşaret Dili Oynatma',
                  description: 'Metin alanının sağında bulunan oynatma butonuna tıklayarak yazdığınız metne karşılık gelen işaret dilini izleyebilirsiniz. Bu işaret dili, metin oynatma alanının üzerinde gösterilecektir.',
                ),
                SizedBox(height: 16),
                buildHelpItem(
                  context,
                  number: '4',
                  title: 'Ana Menüye Dönüş',
                  description: 'Başka sayfalara geçtiğinizde, uygulamanın alt menüsünde ortada bulunan işaret dili ikonuna sahip butona basarak ana menüye geri dönebilirsiniz.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHelpItem(BuildContext context, {required String number, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$number. ',
          style: TextStyle(
            color: SeenSoundTheme.nearlyDarkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: SeenSoundTheme.darkerText,
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: SeenSoundTheme.darkText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
