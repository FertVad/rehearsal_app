import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:rehearsal_app/core/navigation/app_shell.dart';
import 'package:rehearsal_app/features/about/presentation/about_page.dart';
import 'package:rehearsal_app/features/auth/presentation/auth_page.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    redirect: (context, state) {
      // This will be handled by the redirect logic below
      return null;
    },
    refreshListenable: null,
    routes: <RouteBase>[
      // Auth route
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthPage(),
      ),
      
      // Main app routes (protected)
      GoRoute(
        path: '/',
        builder: (context, state) => const AppShell(),
        routes: [
          GoRoute(
            path: 'about',
            builder: (context, state) => const AboutPage(),
          ),
        ],
      ),
      
      // Redirects for backwards compatibility
      GoRoute(
        path: '/dashboard',
        redirect: (_, _) => '/',
      ),
      GoRoute(
        path: '/calendar',
        redirect: (_, _) => '/',
      ),
      GoRoute(
        path: '/availability',
        redirect: (_, _) => '/',
      ),
      GoRoute(
        path: '/projects',
        redirect: (_, _) => '/',
      ),
    ],
  );
}

// Helper class to make a stream listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

