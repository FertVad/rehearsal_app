import 'package:flutter/material.dart';
import 'package:rehearsal_app/l10n/app.dart';

/// Helper class for common localization utilities
class LocalizationHelper {
  const LocalizationHelper._();

  /// Get localized month names (full)
  static List<String> getMonthNames(BuildContext context) {
    final l10n = context.l10n;
    return [
      l10n.january,
      l10n.february,
      l10n.march,
      l10n.april,
      l10n.may,
      l10n.june,
      l10n.july,
      l10n.august,
      l10n.september,
      l10n.october,
      l10n.november,
      l10n.december,
    ];
  }

  /// Get localized month names (short)
  static List<String> getMonthNamesShort(BuildContext context) {
    final l10n = context.l10n;
    return [
      l10n.jan,
      l10n.feb,
      l10n.mar,
      l10n.apr,
      l10n.may, // May is same in short form
      l10n.jun,
      l10n.jul,
      l10n.aug,
      l10n.sep,
      l10n.oct,
      l10n.nov,
      l10n.dec,
    ];
  }

  /// Format date with localized month name
  static String formatDate(BuildContext context, DateTime date, {bool shortMonth = false}) {
    final months = shortMonth 
      ? getMonthNamesShort(context)
      : getMonthNames(context);
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Format relative date (Today, Tomorrow, or date)
  static String formatRelativeDate(BuildContext context, DateTime date) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    
    if (targetDate == today) {
      return l10n.today;
    } else if (targetDate == today.add(const Duration(days: 1))) {
      return l10n.tomorrow;
    } else {
      return formatDate(context, date, shortMonth: true);
    }
  }
}