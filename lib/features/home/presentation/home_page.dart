import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rehearsal App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Добро пожаловать! Это стартовый экран.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/about'),
              child: const Text('О приложении'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/calendar'),
              child: const Text('Календарь'),
            ),
          ],
        ),
      ),
    );
  }
}
