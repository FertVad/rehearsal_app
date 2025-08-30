import 'package:go_router/go_router.dart';
import 'package:rehearsal_app/features/about/presentation/about_page.dart';
import 'package:rehearsal_app/features/home/presentation/home_page.dart';
import 'package:rehearsal_app/features/calendar/presentation/calendar_page.dart';
import 'package:rehearsal_app/features/availability/presentation/availability_page.dart';

class AppRouter {
  AppRouter();

  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarPage(),
      ),
      GoRoute(
        path: '/availability',
        builder: (context, state) => const AvailabilityPage(),
      ),
    ],
  );
}
