/// Example of how to properly use the centralized provider index
/// This demonstrates best practices for importing and using providers

// ✅ CORRECT: Import from central index
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/providers/index.dart';
import 'package:rehearsal_app/core/settings/user_settings.dart';

class ProperProviderUsageExample extends ConsumerWidget {
  const ProperProviderUsageExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ GOOD: Clear distinction between different user providers
    final authUser = ref.watch(currentUserProvider);              // StreamProvider<User?> from auth
    final userId = ref.watch(currentUserIdProvider);              // Provider<String?> from user state
    final userState = ref.watch(authAwareUserControllerProvider); // Provider<UserState> auth-aware
    
    // ✅ GOOD: Settings providers with clear purposes
    final themeMode = ref.watch(themeProvider);                   // Provider<ThemeMode> read-only
    final locale = ref.watch(localeProvider);                     // NotifierProvider<LocaleNotifier, Locale?> 
    final settings = ref.watch(settingsProvider);                 // StateNotifierProvider for full settings
    
    // ✅ GOOD: Repository providers for data access
    final usersRepo = ref.watch(usersRepositoryProvider);         // Provider<UsersRepository>
    final availabilityRepo = ref.watch(availabilityRepositoryProvider); // Provider<AvailabilityRepository>
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider Usage Example'),
      ),
      body: Column(
        children: [
          // Display current user info
          authUser.when(
            data: (user) => Text('Auth User: ${user?.email ?? 'Not logged in'}'),
            loading: () => CircularProgressIndicator(),
            error: (error, _) => Text('Auth Error: $error'),
          ),
          
          // Display user ID from state
          Text('User ID from state: ${userId ?? 'None'}'),
          
          // Display current theme
          Text('Current Theme: $themeMode'),
          
          // Display current locale
          Text('Current Locale: ${locale?.languageCode ?? 'System'}'),
          
          // Language switching example
          ElevatedButton(
            onPressed: () {
              // ✅ GOOD: Use provider's built-in method for state changes
              ref.read(localeProvider.notifier).changeLocale(
                locale?.languageCode == 'en' 
                  ? const Locale('ru') 
                  : const Locale('en'),
              );
            },
            child: Text('Toggle Language'),
          ),
          
          // Theme switching example
          ElevatedButton(
            onPressed: () {
              // ✅ GOOD: Use settings provider for theme changes
              ref.read(settingsProvider.notifier).updateTheme(
                themeMode == ThemeMode.dark 
                  ? AppTheme.light 
                  : AppTheme.dark,
              );
            },
            child: Text('Toggle Theme'),
          ),
        ],
      ),
    );
  }
}

// ❌ BAD EXAMPLE - DON'T DO THIS
/*
import 'package:rehearsal_app/core/auth/auth_provider.dart';
import 'package:rehearsal_app/core/settings/settings_provider.dart';

class BadProviderUsageExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ❌ BAD: Direct imports make conflicts more likely
    // ❌ BAD: Unclear which currentUserProvider is being used
    final user = ref.watch(currentUserProvider); // Which one??
    
    return Container();
  }
}
*/

/// Note: AppTheme enum is defined in lib/core/settings/user_settings.dart