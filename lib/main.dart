import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/supabase/supabase_config.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone data
  tz.initializeTimeZones();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  runApp(ProviderScope(child: App()));
}
