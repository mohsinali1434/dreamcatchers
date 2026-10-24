import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String get supabaseUrl {
    const envUrl = String.fromEnvironment('SUPABASE_URL');
    if (envUrl.isNotEmpty) return envUrl;
    return dotenv.env['SUPABASE_URL'] ?? 'https://your-project-id.supabase.co';
  }

  static String get supabasePublishableKey {
    const envKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
    if (envKey.isNotEmpty) return envKey;
    return dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? 'your-supabase-anon-key';
  }

  static const String postMediaBucket = 'post-media';
}
