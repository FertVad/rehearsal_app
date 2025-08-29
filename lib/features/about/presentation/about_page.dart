import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('О приложении')),
      body: Center(child: Text('Rehearsal App v0.1')),
    );
  }
}
