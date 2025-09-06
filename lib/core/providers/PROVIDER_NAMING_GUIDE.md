# Provider Naming Conventions Guide

## Overview
This guide establishes consistent naming conventions for Riverpod providers to prevent conflicts and improve code readability.

## Naming Rules

### 1. Provider Type Suffixes
Always end provider names with the appropriate suffix:

- **StateProvider** → `Provider` suffix
  ```dart
  final selectedDateProvider = StateProvider<DateTime?>(...)
  final navigationIndexProvider = StateProvider<int>(...)
  ```

- **Provider** (read-only) → `Provider` suffix  
  ```dart
  final themeProvider = Provider<ThemeMode>(...)
  final currentUserIdProvider = Provider<String?>(...)
  ```

- **NotifierProvider** → `Provider` suffix
  ```dart
  final userControllerProvider = NotifierProvider<UserController, UserState>(...)
  final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(...)
  ```

- **StreamProvider** → `Provider` suffix
  ```dart
  final currentUserProvider = StreamProvider<User?>(...)
  ```

- **FutureProvider** → `Provider` suffix
  ```dart
  final userProfileProvider = FutureProvider<Map<String, dynamic>?>(...)
  ```

### 2. Semantic Naming Patterns

#### Controllers and State Management
- Format: `{feature}ControllerProvider`
- Examples: `userControllerProvider`, `availabilityControllerProvider`

#### Current/Selected State
- Format: `current{Entity}Provider` or `selected{Entity}Provider`
- Examples: `currentUserProvider`, `selectedDateProvider`

#### Data Access
- Format: `{entity}RepositoryProvider`
- Examples: `usersRepositoryProvider`, `rehearsalsRepositoryProvider`

#### Services
- Format: `{service}ServiceProvider`
- Examples: `authServiceProvider`, `notificationServiceProvider`

### 3. Avoiding Conflicts

#### Problem: Multiple providers for the same concept
```dart
// ❌ BAD - Naming conflict
final currentUserProvider = StreamProvider<User?>(...)      // From auth
final currentUserProvider = Provider<String?>(...)          // From user management
```

#### Solution: Be specific about the data type/purpose
```dart
// ✅ GOOD - Clear distinction
final currentUserProvider = StreamProvider<User?>(...)      // Auth user object
final currentUserIdProvider = Provider<String?>(...)        // Just the ID
```

### 4. Documentation Requirements

Every provider must have documentation following this format:

```dart
/// {ProviderName} - {Brief description}
/// {Detailed explanation of purpose and usage}
/// {Any warnings or notes about similar providers}
final exampleProvider = Provider<Type>((ref) {
  // implementation
});
```

Example:
```dart
/// Current user provider - Stream of authenticated user
/// Returns User object when authenticated, null when not
/// DO NOT confuse with currentUserIdProvider from user_provider.dart
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges.map((state) => state.session?.user);
});
```

## Checklist for New Providers

Before adding a new provider:

1. ✅ Check `lib/core/providers/index.dart` for existing similar providers
2. ✅ Follow naming conventions (see patterns above)
3. ✅ Add comprehensive documentation
4. ✅ Export from `index.dart` with documentation
5. ✅ Update `providerRegistry` map in `index.dart`
6. ✅ Test for naming conflicts (compilation will fail if conflicts exist)

## Migration Strategy

When renaming existing providers:

1. Add new provider with correct name
2. Deprecate old provider with `@Deprecated()` annotation
3. Update all usages to new provider
4. Remove deprecated provider after 1-2 releases

Example:
```dart
@Deprecated('Use currentUserIdProvider instead. Will be removed in v2.0')
final currentUserProvider = Provider<String?>(...);

/// Current user ID provider - Extracts user ID from UserState  
final currentUserIdProvider = Provider<String?>(...);
```

## Best Practices

### 1. Use Descriptive Names
```dart
// ❌ BAD - Too generic
final dataProvider = Provider<List<Object>>(...)

// ✅ GOOD - Specific purpose
final upcomingRehearsalsProvider = Provider<List<Rehearsal>>(...)
```

### 2. Group Related Providers
```dart
// User management group
final userControllerProvider = NotifierProvider<UserController, UserState>(...)
final currentUserIdProvider = Provider<String?>(...)
final authAwareUserControllerProvider = Provider<UserState>(...)

// Settings group  
final settingsProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<UserSettings>>(...)
final themeProvider = Provider<ThemeMode>(...)
final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(...)
```

### 3. Consistent Import Strategy
Always import providers from the central index:
```dart
// ✅ GOOD - Single source of truth
import 'package:rehearsal_app/core/providers/index.dart';

// ❌ BAD - Direct imports create confusion
import 'package:rehearsal_app/features/user/controller/user_provider.dart';
import 'package:rehearsal_app/core/auth/auth_provider.dart';
```

## Examples of Good Provider Names

| Purpose | Provider Name | Type |
|---------|---------------|------|
| Auth user stream | `currentUserProvider` | StreamProvider<User?> |
| User ID from state | `currentUserIdProvider` | Provider<String?> |
| User profile data | `userProfileProvider` | FutureProvider<Map<String, dynamic>?> |
| User state management | `userControllerProvider` | NotifierProvider |
| App theme | `themeProvider` | Provider<ThemeMode> |
| App language | `localeProvider` | NotifierProvider<LocaleNotifier, Locale?> |
| Selected calendar date | `selectedCalendarDateProvider` | StateProvider<DateTime?> |
| Navigation index | `navigationIndexProvider` | StateProvider<int> |

This guide ensures consistent, conflict-free provider naming across the entire application.