import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static String get url {
    final envUrl = dotenv.env['SUPABASE_URL'];
    if (envUrl == null || envUrl.isEmpty) {
      throw Exception('SUPABASE_URL not found in environment variables');
    }
    return envUrl;
  }
  
  static String get anonKey {
    final envKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (envKey == null || envKey.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY not found in environment variables');
    }
    return envKey;
  }
  
  static Future<void> initialize() async {
    // Загружаем .env файл
    await dotenv.load(fileName: ".env");
    
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: dotenv.env['FLUTTER_ENV'] == 'development',
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}