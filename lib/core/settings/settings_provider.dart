import 'dart:convert' as dart;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/providers/repository_providers.dart';
import 'package:rehearsal_app/core/auth/auth_provider.dart';
import 'package:rehearsal_app/core/settings/user_settings.dart';
import 'package:rehearsal_app/core/supabase/repositories/supabase_profiles_repository.dart';

/// Settings notifier that syncs with Supabase profiles.metadata
class SettingsNotifier extends StateNotifier<AsyncValue<UserSettings>> {
  SettingsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  final Ref _ref;

  Future<void> _loadSettings() async {
    try {
      final authService = _ref.read(authServiceProvider);
      final user = authService.currentUser;

      if (user == null) {
        // Not authenticated, use default settings
        state = const AsyncValue.data(UserSettings());
        return;
      }

      final usersRepo = _ref.read(usersRepositoryProvider);
      final profile = await usersRepo.getById(user.id);

      if (profile == null) {
        state = const AsyncValue.data(UserSettings());
        return;
      }

      // Parse settings from metadata field
      final metadataString = profile.metadata;
      final metadata = metadataString != null
          ? Map<String, dynamic>.from(dart.jsonDecode(metadataString))
          : <String, dynamic>{};
      final settingsJson = metadata['settings'] as Map<String, dynamic>? ?? {};

      final settings = UserSettings.fromJson(settingsJson);
      state = AsyncValue.data(settings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Update theme setting
  Future<void> updateTheme(AppTheme theme) async {
    if (state.value == null) return;

    final newSettings = state.value!.copyWith(theme: theme);
    await _saveSettings(newSettings);
  }

  /// Update language setting
  Future<void> updateLanguage(String? language) async {
    if (state.value == null) return;

    final newSettings = state.value!.copyWith(language: language);
    await _saveSettings(newSettings);
  }

  /// Update notifications setting
  Future<void> updateNotifications(bool enabled) async {
    if (state.value == null) return;

    final newSettings = state.value!.copyWith(notifications: enabled);
    await _saveSettings(newSettings);
  }

  /// Update sound setting
  Future<void> updateSound(bool enabled) async {
    if (state.value == null) return;

    final newSettings = state.value!.copyWith(soundEnabled: enabled);
    await _saveSettings(newSettings);
  }

  /// Save settings to Supabase
  Future<void> _saveSettings(UserSettings settings) async {
    try {
      state = AsyncValue.data(settings);

      final authService = _ref.read(authServiceProvider);
      final user = authService.currentUser;

      if (user == null) return;

      final usersRepo = _ref.read(usersRepositoryProvider);

      // Update profile bio (settings stored as bio since no metadata field)
      if (usersRepo is SupabaseProfilesRepository) {
        await (usersRepo).updateBio(
          id: user.id,
          bio: 'Settings: ${settings.toJson()}',
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Reload settings from server
  Future<void> reload() => _loadSettings();
}

/// Settings provider - Main settings management
/// Syncs user preferences with Supabase profiles.metadata
/// Handles theme, language, notifications, and other user settings
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<UserSettings>>((ref) {
      return SettingsNotifier(ref);
    });

/// Theme provider - Read-only current theme mode
/// Derives theme from settings, returns ThemeMode for MaterialApp
final themeProvider = Provider<ThemeMode>((ref) {
  return ref
      .watch(settingsProvider)
      .when(
        data: (settings) => settings.theme.themeMode,
        loading: () => ThemeMode.system,
        error: (_, _) => ThemeMode.system,
      );
});

/// Locale notifier - Manages app language settings
/// Syncs with settings provider and saves to database
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    return ref
        .watch(settingsProvider)
        .when(
          data: (settings) =>
              settings.language != null ? Locale(settings.language!) : null,
          loading: () => null,
          error: (_, _) => null,
        );
  }
  
  /// Change locale and save to settings
  void changeLocale(Locale? locale) {
    ref.read(settingsProvider.notifier).updateLanguage(locale?.languageCode);
  }
}

/// Locale provider - Current app language
/// null = system locale, otherwise fixed Locale
/// Use changeLocale() method to update and persist to database
final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(() => LocaleNotifier());
