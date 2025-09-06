import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/haptics.dart';
import 'package:rehearsal_app/core/providers/index.dart';
import 'package:rehearsal_app/features/dashboard/widgets/day_scroller.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dashboard_header.dart';
import 'package:rehearsal_app/features/dashboard/widgets/upcoming_rehearsals.dart';
import 'package:rehearsal_app/features/dashboard/widgets/project_availability.dart';
import 'package:rehearsal_app/features/dashboard/widgets/quick_actions.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
import 'package:rehearsal_app/features/rehearsals/presentation/rehearsal_create_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  DateTime _selectedDate = DateTime.now(); // Изначально выбрано сегодняшнее число
  final Map<String, bool> _eventCache = {}; // Кэш для событий по датам

  // Функция проверки наличия событий на дату
  bool _hasEventsOnDate(DateTime date) {
    final dateKey = '${date.year}-${date.month}-${date.day}';
    return _eventCache[dateKey] ?? false;
  }

  @override
  void initState() {
    super.initState();
    // Загружаем события при инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEventsForRange(DateTime.now());
    });
  }

  // Асинхронно загружаем информацию о событиях для видимого диапазона
  void _loadEventsForRange(DateTime centerDate) async {
    try {
      final rehearsalsRepo = ref.read(rehearsalsRepositoryProvider);
      final userId = ref.read(currentUserIdProvider) ?? 'anonymous';
      final selectedProjectIds = ref.read(selectedProjectsFilterProvider);
      
      // Загружаем события на ±10 дней от центральной даты
      final startDate = centerDate.subtract(const Duration(days: 10));
      final endDate = centerDate.add(const Duration(days: 10));
      
      final rehearsals = await rehearsalsRepo.listForUserInRange(
        userId: userId,
        fromUtc: startDate.toUtc().millisecondsSinceEpoch,
        toUtc: endDate.toUtc().millisecondsSinceEpoch,
      );
      
      // Фильтруем по выбранным проектам
      final filteredRehearsals = selectedProjectIds.isEmpty 
          ? rehearsals 
          : rehearsals.where((r) => selectedProjectIds.contains(r.projectId)).toList();
      
      // Обновляем кэш
      if (mounted) {
        setState(() {
          _eventCache.clear();
          for (final rehearsal in filteredRehearsals) {
            final date = DateTime.fromMillisecondsSinceEpoch(
              rehearsal.startsAtUtc,
              isUtc: true,
            ).toLocal();
            final dateKey = '${date.year}-${date.month}-${date.day}';
            _eventCache[dateKey] = true;
          }
        });
      }
    } catch (e) {
      // Игнорируем ошибки загрузки событий
    }
  }

  void _handleDateChanged(DateTime date) {
    // Этот метод вызывается только когда пользователь явно выбирает дату (тап)
    // НЕ вызывается при обычном скролле
    setState(() {
      _selectedDate = date;
    });
    // Загружаем события для нового диапазона
    _loadEventsForRange(date);
  }
  
  void _handleDayTap(DateTime date) {
    AppHaptics.selection();
    _handleDateChanged(date); // Повторное использование логики
  }
  
  void _handleDayLongPress(DateTime date) {
    AppHaptics.light();
    _createRehearsalForDate(date);
  }
  
  Future<void> _createRehearsalForDate(DateTime date) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => RehearsalCreatePage(
          selectedDate: date,
        ),
      ),
    );
    
    if (result == true) {
      // Refresh the page
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Слушаем изменения фильтра проектов и обновляем события
    ref.listen(selectedProjectsFilterProvider, (previous, next) {
      _loadEventsForRange(DateTime.now());
    });
    
    return Scaffold(
      body: DashBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: CustomScrollView(
              slivers: [
              // Header with greeting
              SliverToBoxAdapter(
                child: DashboardHeader(),
              ),

              // Day scroller
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: SizedBox(
                    height: 120,
                    child: DayScroller(
                      initialDate: DateTime.now(), // Показывать календарь с сегодняшней даты
                      selectedDate: _selectedDate, // Выделенный день (сегодняшний по умолчанию)
                      eventPredicate: _hasEventsOnDate, // Проверка наличия событий
                      onDayTap: _handleDayTap, // Только явные тапы
                      onDayLongPress: _handleDayLongPress,
                    ),
                  ),
                ),
              ),

              // Upcoming rehearsals
              SliverToBoxAdapter(
                child: UpcomingRehearsals(
                  selectedDate: _selectedDate,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.lg),
              ),

              // Project availability
              const SliverToBoxAdapter(
                child: ProjectAvailability(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.lg),
              ),

              // Quick actions
              const SliverToBoxAdapter(
                child: QuickActions(),
              ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xl),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

