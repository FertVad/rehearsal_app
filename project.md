# Анализ Flutter-кодовой базы: Rehearsal App

## 📁 Структура проекта
```
rehearsal_app/
├── lib/
│   ├── core/               # общие сервисы, дизайн‑система, провайдеры, навигация
│   ├── domain/             # модели и интерфейсы репозиториев
│   ├── data/               # реализации репозиториев и источников данных
│   ├── features/           # UI и контроллеры отдельных фич
│   ├── l10n/               # локализация (ARB + хелперы)
│   ├── app.dart            # корневой виджет приложения
│   └── main.dart           # точка входа и инициализация
├── test/                  # минимальные widget‑тесты
├── android/, ios/, ...    # стандартные платформенные конфиги
├── web/                   # манифест и иконки для web
└── .github/workflows/     # CI сценарий GitHub Actions
```

Код организован по принципам **Clean Architecture** с разделением на слои `domain` → `data` → `features/presentation`. В `lib/core` собраны кросс‑фичевые сервисы и дизайн‑система. State management и DI строятся вокруг Riverpod‑провайдеров.

## 🛠 Технологический стек

| Технология | Версия | Назначение |
|------------|--------|------------|
| Flutter SDK | ≥3.29.0 | основы приложения и виджеты |
| Dart SDK | ≥3.8.0 <4.0.0 | язык и runtime |
| go_router | 16.2.1 | декларативная навигация, редиректы |
| flutter_riverpod | 2.5.1 | управление состоянием, DI |
| supabase_flutter | 2.9.0 | аутентификация и БД Supabase |
| timezone | 0.10.1 | работа с таймзонами |
| intl | 0.20.2 | локализация и форматирование |
| shared_preferences | 2.2.2 | локальное сохранение простых настроек |
| flutter_dotenv | 6.0.0 | загрузка .env переменных |
| uuid | 4.5.1 | генерация идентификаторов |
| flutter_lints | 6.0.0 | набор правил линтера |

## 🏗 Архитектура

### Слои и зависимости
- **main.dart** инициализирует таймзоны, Supabase и оборачивает приложение в `ProviderScope` Riverpod.
```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await SupabaseConfig.initialize();
  runApp(ProviderScope(child: App()));
}
```
- **App** строит `MaterialApp.router`, подключая тему, локализацию и конфиг маршрутов.
```dart
class App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      locale: locale,
      theme: buildAppTheme(),
      darkTheme: buildAppDarkTheme(),
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
```

### Навигация
Используется `GoRouter` с проверкой авторизации и публичными ссылками приглашений.
```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/auth',
    redirect: (context, state) {
      final auth = ref.read(authServiceProvider);
      final isAuthenticated = auth.isAuthenticated;
      final isGoingToInvite = state.matchedLocation.startsWith('/join/');
      if (isGoingToInvite) return null;
      if (!isAuthenticated && state.matchedLocation != '/auth') return '/auth';
      if (isAuthenticated && state.matchedLocation == '/auth') return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (_) => const AuthPage()),
      GoRoute(path: '/join/:slug', builder: (c, s) => InviteHandlerPage(inviteSlug: s.pathParameters['slug']!)),
      GoRoute(path: '/', builder: (_) => const AppShell(), routes: [
        GoRoute(path: 'about', builder: (_) => const AboutPage()),
      ]),
    ],
  );
});
```

### Управление состоянием и DI
Централизованный индекс провайдеров экспортирует все источники состояния.
```dart
// core/providers/index.dart (фрагмент)
export 'core/auth/auth_provider.dart' show authServiceProvider, authNotifierProvider;
export 'features/user/controller/user_provider.dart' show userControllerProvider;
export 'core/settings/settings_provider.dart' show settingsProvider, themeProvider, localeProvider;
export 'core/providers/repository_providers.dart' show usersRepositoryProvider, projectsRepositoryProvider;
```
Пример контроллера пользователя на Riverpod Notifier:
```dart
class UserController extends Notifier<UserState> {
  @override
  UserState build() {
    _initializeUser();
    return const UserState(currentUser: null, isLoading: true);
  }

  Future<void> _initializeUser() async {
    final authService = ref.read(authServiceProvider);
    final supabaseUser = authService.currentUser;
    if (supabaseUser != null) {
      await _loadUser(supabaseUser.id);
    } else {
      state = state.copyWith(currentUser: null, isLoading: false,
          error: 'No authenticated user. Please sign up or log in.');
    }
  }
}
```

### API и работа с данными
Репозитории реализуют обращение к Supabase через общий `SupabaseDataSource`.
```dart
class UsersRepositoryImpl extends BaseRepository implements UsersRepository {
  @override
  Future<User?> getById(String id) async {
    return await safeExecute(() async {
      final response = await _dataSource.selectById(table: _tableName, id: id);
      if (response == null) return null;
      return _mapToUser(response, lastWriter: 'supabase:user');
    }, operationName: 'GET_BY_ID', tableName: _tableName, recordId: id);
  }

  User _mapToUser(Map<String, dynamic> json, {required String lastWriter}) {
    final timestamps = extractTimestamps(json);
    return User(
      id: json['id'],
      createdAtUtc: timestamps['createdAtUtc']!,
      updatedAtUtc: timestamps['updatedAtUtc']!,
      deletedAtUtc: timestamps['deletedAtUtc'],
      lastWriter: lastWriter,
      name: json['full_name']?.toString(),
      email: json['email']?.toString(),
      tz: json['timezone']?.toString() ?? 'UTC',
      metadata: _formatNotificationSettings(json['notification_settings']),
    );
  }
}
```

### Обработка ошибок и асинхронность
- Репозитории оборачивают операции в `safeExecute` с централизованным логированием.
- Контроллеры используют `try/catch` и выставляют `error` в состоянии.
- Глобальных хендлеров (`runZonedGuarded`, `FlutterError.onError`) не обнаружено.

### DI‑граф
Инициализация провайдеров происходит в `main.dart` через `ProviderScope`. Из-за Riverpod граф устойчив к hot‑reload.

## 🎨 UI/UX и стилизация
- Темы определены в `core/design_system/theme.dart` и строятся на `ColorScheme.fromSeed`, поддерживают светлый и тёмный режимы.
- Используется собственная дизайн‑система (цвета, типографика, отступы) и стеклянные панели на `BackdropFilter`.
```dart
class AppGlass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    return ClipRRect(
      borderRadius: BorderRadius.circular(config.radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: config.blurIntensity, sigmaY: config.blurIntensity),
        child: Container(
          padding: padding ?? config.defaultPadding,
          decoration: BoxDecoration(gradient: _getGradient(brightness)),
          child: child,
        ),
      ),
    );
  }
}
```
- Локализация через `flutter_localizations` и ARB‑файлы (`app_en.arb`, `app_ru.arb`).
- Адаптивность ограничена – вёрстка в основном рассчитана на мобильные устройства; специальных брейкпоинтов для планшетов/веб нет.
- Доступность (семантика, контраст) явно не проработана.

## ⚙️ Производительность
- Большинство виджетов помечены `const`, но сложные страницы (`AuthPage`, `CalendarPage`) содержат большие `build()` без мемоизации.
- Списки строятся через `ListView`/`Sliver` в `CalendarPage`, ленивой подгрузки данных нет.
- Изображения/шейдеры не оптимизируются, `ImageCache` не настроен.
- Работа с сетью полностью онлайн; офлайн‑кэширование отсутствует.
- Потенциальные улучшения: разделение виджетов на мелкие, `select()`/`ref.watch` с селекторами для снижения rebuild’ов, кэширование ответов Supabase.

## ✅ Качество кода и тесты
- Линтер: `flutter_lints` без дополнительных правил.
- Стиль кода в целом единообразный, имеются комментарии и документация.
- Тесты: один базовый widget‑тест для bottom‑navigation; отсутствуют unit, golden и integration тесты.
- CI: GitHub Actions запускает `flutter analyze`, `flutter test --coverage` и web‑сборку.

## 🔧 Ключевые модули

### 1. AuthPage
Назначение: регистрация и вход, поддержка email/пароля и Google OAuth.
```dart
class AuthPage extends ConsumerStatefulWidget { ... }
// В обработчике submit вызывается authNotifierProvider
final authNotifier = ref.read(authNotifierProvider.notifier);
error = await authNotifier.signUp(email: _email, password: _password);
```
Внешние зависимости: `authNotifierProvider`, локализация, дизайн‑система. Риски: большие методы `_handleSubmit`, множество `setState` – возможны лишние перерисовки.

### 2. AppShell
Назначение: каркас приложения с нижней навигацией и `IndexedStack`.
```dart
final navigationIndexProvider = StateProvider<int>((ref) => 0);
Scaffold(
  body: IndexedStack(index: currentIndex, children: const [...]),
  bottomNavigationBar: NavigationBar(
    selectedIndex: currentIndex,
    onDestinationSelected: (index) {
      ref.read(navigationIndexProvider.notifier).state = index;
      Haptics.selection();
    },
    destinations: [...],
  ),
);
```
Зависимости: провайдер состояния навигации, локализация, дизайн‑система. Риск: все страницы держатся в памяти; при росте числа вкладок стоит рассмотреть lazy‑load.

### 3. UserController
Назначение: загрузка/обновление профиля пользователя и синхронизация с Supabase.
```dart
class UserController extends Notifier<UserState> {
  Future<void> _loadUser(String userId) async {
    final usersRepo = ref.read(usersRepositoryProvider);
    final user = await usersRepo.getById(userId);
    if (user != null) {
      state = state.copyWith(currentUser: user, isLoading: false);
    } else {
      await authService.ensureUserProfile(userId: userId, ...);
      final fallbackUser = await _createFallbackUser(supabaseUser);
      state = state.copyWith(currentUser: fallbackUser, isLoading: false);
    }
  }
}
```
Внешние зависимости: `usersRepositoryProvider`, `authServiceProvider`. Риски: множественные `Future.delayed` и повторные запросы при инициализации.

### 4. UsersRepositoryImpl
Назначение: доступ к таблице `users` Supabase, преобразование DTO → domain.
```dart
Future<User?> getById(String id) async {
  return await safeExecute(() async {
    final response = await _dataSource.selectById(table: _tableName, id: id);
    if (response == null) return null;
    return _mapToUser(response, lastWriter: 'supabase:user');
  }, operationName: 'GET_BY_ID', tableName: _tableName, recordId: id);
}
```
Зависимости: `SupabaseDataSource`, `Logger`. Риск: все операции выполняются онлайн, нет ретраев/таймаутов.

### 5. CalendarPage
Назначение: отображение календаря и выбор дат.
```dart
final selectedCalendarDateProvider = StateProvider<DateTime?>((ref) => null);
final currentCalendarMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

return Scaffold(
  appBar: AppBar(title: Text(context.l10n.navCalendar)),
  body: DashBackground(
    child: RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: CustomScrollView(slivers: [...]),
    ),
  ),
);
```
Зависимости: провайдеры дат, дизайн‑система, локализация. Риски: отсутствие кэширования событий, возможные длительные загрузки.

## 🚀 Инфраструктура
- **CI/CD**: GitHub Actions устанавливает Flutter, генерирует код (`build_runner`), запускает анализатор, тесты и сборку web.
- **Flavors/окружения**: отсутствуют, но переменные окружения загружаются через `.env`.
- **Аналитика/крэш‑репорты**: не интегрированы (нет Firebase Crashlytics/Sentry).
- **Нативные разрешения**: AndroidManifest/Info.plist содержат только базовые настройки без дополнительных разрешений.

## 📋 Выводы и рекомендации
**Сильные стороны**
- Чёткая архитектура с разделением на слои и централизованными провайдерами.
- Хорошо оформленная дизайн‑система и поддержка тёмной темы.
- Полноценная локализация (EN/RU) и настройка пользователя через Supabase.

**Риски**
- Минимальное тестовое покрытие и отсутствие CI проверок на уровне бизнеса.
- Отсутствие глобальной обработки ошибок и офлайн‑поддержки.
- Потенциальные проблемы производительности на сложных страницах.

**Quick wins (1–2 недели)**
- Добавить unit/widget/golden тесты ключевых компонентов.
- Включить `flutter analyze`/`dart analyze` локально и расширить правила линтера.
- Вынести тяжёлые виджеты в отдельные `ConsumerWidget`/`select` для сокращения rebuild’ов.

**Среднесрочные улучшения**
- Реализовать кэширование запросов и офлайн‑режим (например, через `isar`/`hive`).
- Добавить Crashlytics/Sentry и централизованный `ErrorHandler`.
- Оптимизировать навигацию и подгрузку страниц (lazy‑load, разделение по модулям).

**Уровень сложности проекта**: ориентирован на **middle** разработчиков; наличие собственной дизайн‑системы и чистой архитектуры требует понимания паттернов, но код достаточно прямолинейный для изучения.

