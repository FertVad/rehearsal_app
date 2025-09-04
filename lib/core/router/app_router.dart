import 'package:go_router/go_router.dart';
import 'package:rehearsal_app/core/navigation/app_shell.dart';
import 'package:rehearsal_app/features/about/presentation/about_page.dart';

class AppRouter {
  AppRouter();

  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const AppShell(), // ИЗМЕНЕНО с HomePage
        routes: [
          GoRoute(
            path: 'about',
            builder: (context, state) => const AboutPage(),
          ),
        ],
      ),
      // Редиректы для обратной совместимости
      GoRoute(
        path: '/dashboard',
        redirect: (_, __) => '/',
      ),
      GoRoute(
        path: '/calendar',
        redirect: (_, __) => '/',
      ),
      GoRoute(
        path: '/availability',
        redirect: (_, __) => '/',
      ),
      GoRoute(
        path: '/projects',
        redirect: (_, __) => '/',
      ),
    ],
  );
}

