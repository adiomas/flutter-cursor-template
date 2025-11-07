import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'common/domain/app_environment.dart';
import 'common/domain/notifiers/theme_notifier.dart';
import 'common/domain/router/app_router.dart';
import 'common/presentation/widgets/developer_console/developer_console_overlay.dart';
import 'common/presentation/widgets/dismiss_keyboard.dart';
import 'common/utils/error_handler/global_error_handler.dart';
import 'common/utils/logger/app_logger.dart';
import 'l10n/generated/app_localizations.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize environment
  EnvInfo.initialize(AppEnvironment.dev);

  // Initialize global error handler
  GlobalErrorHandler.initialize();

  // Initialize logger
  AppLogger.instance.info('🚀 GlowAI starting...');
  AppLogger.instance.info('Environment: ${EnvInfo.environment.name}');

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: EnvInfo.supabaseUrl,
      anonKey: EnvInfo.supabaseAnonKey,
    );
    AppLogger.instance.info('✅ Supabase initialized successfully');
  } catch (e, stackTrace) {
    AppLogger.instance.error(
      'Failed to initialize Supabase',
      error: e,
      stackTrace: stackTrace,
    );
  }

  runApp(
    const ProviderScope(
      child: GlowAIApp(),
    ),
  );
}

class GlowAIApp extends ConsumerWidget {
  const GlowAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    AppLogger.instance.debug('Building GlowAIApp');

    return MaterialApp.router(
      title: EnvInfo.appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.grey900,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.grey900,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.grey50),
          titleTextStyle: TextStyle(
            color: AppColors.grey50,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.grey800,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.grey700),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.grey700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.grey700),
          ),
          color: AppColors.grey800,
        ),
      ),
      routerConfig: router,
      builder: (context, child) {
        return DeveloperConsoleOverlay(
          child: DismissKeyboard(
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
