/// Centralized Provider Index
/// 
/// This file serves as a single source of truth for all providers in the application.
/// It prevents naming conflicts and provides clear documentation of provider purposes.
/// 
/// NAMING CONVENTIONS:
/// - StateProvider: for simple state management (e.g., selectedDateProvider)
/// - Provider: for read-only computed values (e.g., themeProvider)
/// - NotifierProvider: for complex state management (e.g., userControllerProvider)
/// - StreamProvider: for reactive data streams (e.g., currentUserProvider)
library;
/// - FutureProvider: for async computations (e.g., userProfileProvider)

// =============================================================================
// AUTH & USER MANAGEMENT
// =============================================================================

/// Authentication and user session management
export 'package:rehearsal_app/core/auth/auth_provider.dart' show
  authServiceProvider,           // Provider<AuthService> - Auth service singleton
  currentUserProvider,           // StreamProvider<User?> - Current auth user stream
  userProfileProvider,          // FutureProvider<Map<String, dynamic>?> - User profile data
  authNotifierProvider;         // StateNotifierProvider<AuthNotifier, AsyncValue<User?>> - Auth state management

/// User profile and state management  
export 'package:rehearsal_app/features/user/controller/user_provider.dart' show
  userControllerProvider,       // NotifierProvider<UserController, UserState> - User state management
  currentUserIdProvider,        // Provider<String?> - Current user ID (from UserState)
  authAwareUserControllerProvider; // Provider<UserState> - Auth-aware user controller

// =============================================================================
// SETTINGS & PREFERENCES
// =============================================================================

/// Application settings and preferences
export 'package:rehearsal_app/core/settings/settings_provider.dart' show
  settingsProvider,             // StateNotifierProvider<SettingsNotifier, AsyncValue<UserSettings>> - Settings management
  themeProvider,                // Provider<ThemeMode> - Current theme mode
  localeProvider;               // NotifierProvider<LocaleNotifier, Locale?> - Locale management

// =============================================================================
// DATA REPOSITORIES
// =============================================================================

/// Repository providers for data access
export 'package:rehearsal_app/core/providers/repository_providers.dart' show
  availabilityRepositoryProvider, // Provider<AvailabilityRepository> - Availability data access
  rehearsalsRepositoryProvider,  // Provider<RehearsalsRepository> - Rehearsals data access
  usersRepositoryProvider,      // Provider<UsersRepository> - Users data access
  projectsRepositoryProvider,   // Provider<ProjectsRepository> - Projects data access
  repositoryCurrentUserIdProvider; // Provider<String> - Current user ID for repositories

// =============================================================================
// FEATURE-SPECIFIC PROVIDERS
// =============================================================================

/// Availability management
export 'package:rehearsal_app/features/availability/controller/availability_provider.dart' show
  availabilityControllerProvider; // NotifierProvider<AvailabilityController, AvailabilityState> - Availability state

/// Calendar functionality
export 'package:rehearsal_app/features/calendar/providers/calendar_providers.dart' show
  eventDatesProvider,           // FutureProvider.family<List<DateTime>, DateTime> - Event dates for month
  availabilityMapProvider;      // FutureProvider.family<Map<DateTime, AvailabilityStatus>, DateTime> - Availability map

/// Navigation
export 'package:rehearsal_app/core/navigation/app_shell.dart' show
  navigationIndexProvider;      // StateProvider<int> - Bottom nav bar index

/// Routing
export 'package:rehearsal_app/core/router/auth_router.dart' show
  routerProvider;              // Provider<GoRouter> - Application router

// =============================================================================
// PAGE-SPECIFIC PROVIDERS (Consider moving to feature modules)
// =============================================================================

/// Projects page providers
export 'package:rehearsal_app/features/projects/presentation/projects_page.dart' show
  projectsProvider;            // StateProvider<List<Project>> - Projects list

/// Calendar page providers
export 'package:rehearsal_app/features/calendar/presentation/calendar_page.dart' show
  selectedCalendarDateProvider; // StateProvider<DateTime?> - Selected calendar date


