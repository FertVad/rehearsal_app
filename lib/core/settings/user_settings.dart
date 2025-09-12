import 'package:flutter/material.dart';

/// User settings stored in users.notification_settings
class UserSettings {
  const UserSettings({
    this.theme = AppTheme.system,
    this.language,
    this.notifications = true,
    this.soundEnabled = true,
    this.other = const <String, dynamic>{},
  });

  final AppTheme theme;
  final String? language;
  final bool notifications;
  final bool soundEnabled;
  final Map<String, dynamic> other;

  UserSettings copyWith({
    AppTheme? theme,
    String? language,
    bool? notifications,
    bool? soundEnabled,
    Map<String, dynamic>? other,
  }) {
    return UserSettings(
      theme: theme ?? this.theme,
      language: language,
      notifications: notifications ?? this.notifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      other: other ?? this.other,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme.name,
      'language': language,
      'notifications': notifications,
      'soundEnabled': soundEnabled,
      'other': other,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      theme: AppTheme.values.firstWhere(
        (e) => e.name == json['theme'],
        orElse: () => AppTheme.system,
      ),
      language: json['language'] as String?,
      notifications: json['notifications'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      other: Map<String, dynamic>.from(json['other'] ?? {}),
    );
  }
}

enum AppTheme {
  light,
  dark,
  system;

  ThemeMode get themeMode {
    switch (this) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.system:
        return ThemeMode.system;
    }
  }
}
