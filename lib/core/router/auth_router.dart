import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rehearsal_app/core/navigation/app_shell.dart';
import 'package:rehearsal_app/features/about/presentation/about_page.dart';
import 'package:rehearsal_app/features/auth/presentation/auth_page.dart';
import 'package:rehearsal_app/core/auth/auth_provider.dart';

// Router provider that handles authentication
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: '/auth',
    redirect: (context, state) {
      final authService = ref.read(authServiceProvider);
      final isAuthenticated = authService.isAuthenticated;
      final isGoingToAuth = state.matchedLocation == '/auth';
      
      // Debug logging
      if (kDebugMode) {
        print('GoRouter redirect: isAuthenticated=$isAuthenticated, location=${state.matchedLocation}');
      }
      
      // If not authenticated and trying to go to protected route, go to auth
      if (!isAuthenticated && !isGoingToAuth) {
        if (kDebugMode) print('Redirecting to /auth - not authenticated');
        return '/auth';
      }
      
      // If authenticated and on auth page, go to home
      if (isAuthenticated && isGoingToAuth) {
        if (kDebugMode) print('Redirecting to / - authenticated');
        return '/';
      }
      
      // No redirect needed
      if (kDebugMode) print('No redirect needed');
      return null;
    },
    refreshListenable: AuthChangeNotifier(ref),
    routes: <RouteBase>[
      // Auth route
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),
      
      // Main app routes (protected)
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const AppShell(),
        routes: [
          GoRoute(
            path: 'about',
            name: 'about',
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
});

// Helper class to listen to auth state changes
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(this._ref) {
    _subscription = _ref.read(authServiceProvider).authStateChanges.listen(
      (authState) {
        if (kDebugMode) {
          print('AuthChangeNotifier: Auth state changed - user: ${authState.session?.user.id}');
        }
        // Small delay to ensure state is properly updated
        Future.microtask(() => notifyListeners());
      },
    );
  }

  final Ref _ref;
  StreamSubscription<AuthState>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}