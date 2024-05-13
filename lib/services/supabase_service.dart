import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static String get apiUrl => dotenv.env['SUPABASE_API_URL']!;
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY']!;

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    try {
      await Supabase.initialize(url: apiUrl, anonKey: anonKey);
    } catch (e) {
      print('Supabase initialize error: $e');
    }
  }
}
