enum AppEnvironment {
  dev,
  staging,
  prod,
}

class EnvInfo {
  static AppEnvironment _environment = AppEnvironment.dev;

  static void initialize(AppEnvironment environment) {
    _environment = environment;
  }

  // Environment checks
  static AppEnvironment get environment => _environment;
  static bool get isDevelopment => _environment == AppEnvironment.dev;
  static bool get isStaging => _environment == AppEnvironment.staging;
  static bool get isProduction => _environment == AppEnvironment.prod;

  // App configuration
  static String get appTitle {
    return switch (_environment) {
      AppEnvironment.dev => 'GlowAI (DEV)',
      AppEnvironment.staging => 'GlowAI (STAGING)',
      AppEnvironment.prod => 'GlowAI',
    };
  }

  // Supabase configuration (Replace with your actual values)
  static String get supabaseUrl {
    return switch (_environment) {
      AppEnvironment.dev => 'https://fhtuesvhajurucahdwsx.supabase.co',
      AppEnvironment.staging => 'https://your-project.supabase.co',
      AppEnvironment.prod => 'https://your-project.supabase.co',
    };
  }

  static String get supabaseAnonKey {
    return switch (_environment) {
      AppEnvironment.dev =>
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZodHVlc3ZoYWp1cnVjYWhkd3N4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI0NTc3NzcsImV4cCI6MjA3ODAzMzc3N30.nEVBEyE89S-6krYGeZJuRr0ydCa8OTn9-s3ifNBGBFg',
      AppEnvironment.staging => 'your-anon-key-here',
      AppEnvironment.prod => 'your-anon-key-here',
    };
  }

  // OAuth Configuration
  // Google Client IDs - Configure these in your Supabase dashboard
  // Web Client ID is required for all platforms
  // iOS Client ID is optional (only needed for iOS)
  static String? get googleWebClientId {
    // Get from environment variable or return null
    // User should configure this in Supabase dashboard
    return const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
  }

  static String? get googleIosClientId {
    // Get from environment variable or return null
    // Only needed for iOS platform
    return const String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
  }

  // Feature flags
  static bool get enableAnalytics => !isDevelopment;
  static bool get showDebugInfo => isDevelopment;
  static bool get enableDetailedLogging => !isProduction;
}
