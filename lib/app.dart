import 'package:flutter/material.dart';
import 'core/design_system/theme.dart';
import 'core/router/app_router.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rehearsal',
      theme: buildAppTheme(),
      routerConfig: _appRouter.router,
    );
  }
}
