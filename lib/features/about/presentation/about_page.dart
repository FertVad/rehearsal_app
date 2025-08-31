import 'package:flutter/material.dart';
import 'package:rehearsal_app/l10n/app.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.aboutTitle)),
      body: Center(child: Text(context.l10n.aboutVersion)),
    );
  }
}
