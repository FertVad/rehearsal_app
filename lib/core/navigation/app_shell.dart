import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/haptics.dart';
import 'package:rehearsal_app/features/dashboard/presentation/dashboard_page.dart';
import 'package:rehearsal_app/features/calendar/presentation/calendar_page.dart';
import 'package:rehearsal_app/features/availability/presentation/availability_page.dart';
import 'package:rehearsal_app/features/projects/presentation/projects_page.dart';
import 'package:rehearsal_app/features/user/presentation/user_profile_page.dart';
import 'package:rehearsal_app/l10n/app.dart';

// Провайдер для текущего индекса навигации
final navigationIndexProvider = StateProvider<int>((ref) => 0);

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          DashboardPage(),
          CalendarPage(),
          AvailabilityPage(),
          ProjectsPage(),
          UserProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(navigationIndexProvider.notifier).state = index;
          Haptics.selection();
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: context.l10n.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_today_outlined),
            selectedIcon: const Icon(Icons.calendar_today),
            label: context.l10n.navCalendar,
          ),
          NavigationDestination(
            icon: const Icon(Icons.access_time_outlined),
            selectedIcon: const Icon(Icons.access_time_filled),
            label: context.l10n.navAvailability,
          ),
          NavigationDestination(
            icon: const Icon(Icons.folder_outlined),
            selectedIcon: const Icon(Icons.folder),
            label: context.l10n.navProjects,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outlined),
            selectedIcon: const Icon(Icons.person),
            label: context.l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
