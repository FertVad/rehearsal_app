import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://atinuvocevcitsezubqm.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0aW51dm9jZXZjaXRzZXp1YnFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY5OTg5NDYsImV4cCI6MjA3MjU3NDk0Nn0.oischXeF_8bYzEveuPkaWna-JQXooraskhOqZ1UjaDI';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: true, // Enable debug mode for development
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}