import 'package:flutter/material.dart';
import 'core/design_system/theme.dart';
import 'features/home/presentation/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rehearsal',
      theme: buildAppTheme(),
      home: const HomePage(),
    );
  }
}
