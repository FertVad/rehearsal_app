import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// null = системная локаль; иначе фиксированная Locale
final localeProvider = StateProvider<Locale?>((ref) => null);
