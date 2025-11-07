import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/domain/base_state.dart';
import '../../../../common/utils/logger/app_logger.dart';
import '../../../features/auth/domain/entities/user_entity.dart';
import '../../../features/auth/domain/notifiers/auth_notifier.dart';
import '../../../features/auth/presentation/pages/email_sign_up_page.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/auth/presentation/pages/register_page.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../features/debug/presentation/pages/logger_demo_page.dart';
import '../../../features/generate/presentation/pages/generate_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../presentation/extensions/localization_extension.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/widgets/modern_bottom_nav_bar.dart';
import '../app_environment.dart';
import '../navigator_key.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final logger = AppLogger.instance;
  logger.debug('🚦 routerProvider: Building router...');

  // Track user ID changes for redirect logic, but don't rebuild router.
  // Using refreshListenable prevents router from resetting to initialLocation
  // when user ID changes (login/logout).
  final userIdNotifier = ValueNotifier<String?>(null);

  // Initialize userIdNotifier with current value
  final initialAuthState = ref.read(authNotifierProvider);
  final initialUserId = initialAuthState.maybeWhen(
    data: (user) => user?.id,
    orElse: () => null,
  );
  userIdNotifier.value = initialUserId;

  // Listen to user ID changes and update notifier (triggers redirect, not rebuild)
  ref.listen<BaseState<UserEntity?>>(
    authNotifierProvider,
    (previous, next) {
      final newUserId = next.maybeWhen<String?>(
        data: (user) => user?.id,
        orElse: () => null,
      );
      if (userIdNotifier.value != newUserId) {
        logger.info(
            '🚦 routerProvider: User ID changed, triggering redirect (not rebuild)');
        userIdNotifier.value = newUserId;
      }
    },
  );

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: SplashPage.routeName,
    debugLogDiagnostics: true,
    // Use refreshListenable to trigger redirects without rebuilding router
    // This prevents router from resetting to initialLocation on login/logout
    refreshListenable: userIdNotifier,
    routes: [
      // Splash Screen (initial route)
      GoRoute(
        path: SplashPage.routeName,
        builder: (context, state) => const SplashPage(),
      ),
      // Auth Routes
      GoRoute(
        path: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.routeName,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: EmailSignUpPage.routeName,
        builder: (context, state) => const EmailSignUpPage(),
      ),

      // Main App Shell with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          final currentIndex = context.getBottomNavIndex();
          return Scaffold(
            body: child,
            bottomNavigationBar: ModernBottomNavBar(
              currentIndex: currentIndex,
              onTap: (index) => context.navigateToBottomNav(index),
            ),
          );
        },
        routes: [
          GoRoute(
            path: DashboardPage.routeName,
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: GeneratePage.routeName,
            builder: (context, state) => const GeneratePage(),
          ),
          GoRoute(
            path: ProfilePage.routeName,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // Settings (without bottom nav)
      GoRoute(
        path: SettingsPage.routeName,
        builder: (context, state) => const SettingsPage(),
      ),

      // Debug Routes (only in dev/staging)
      if (EnvInfo.isDevelopment || EnvInfo.isStaging)
        GoRoute(
          path: LoggerDemoPage.routeName,
          builder: (context, state) => const LoggerDemoPage(),
        ),
    ],

    // Redirect logic for auth
    // IMPORTANT: Use ref.read() instead of ref.watch() to prevent router rebuilds
    // when auth state changes due to metadata updates (e.g., avatar upload).
    redirect: (context, state) {
      final logger = AppLogger.instance;
      logger
          .debug('🚦 redirect: Called with location: ${state.matchedLocation}');

      // Use ref.read to get current auth state without triggering rebuilds
      final authState = ref.read(authNotifierProvider);
      final isLoggedIn = authState.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );
      logger.debug('🚦 redirect: isLoggedIn: $isLoggedIn');

      final currentLocation = state.matchedLocation;
      final isSplashRoute = currentLocation == SplashPage.routeName;
      final isAuthRoute = currentLocation == LoginPage.routeName ||
          currentLocation == RegisterPage.routeName ||
          currentLocation == EmailSignUpPage.routeName;
      final isProtectedRoute = currentLocation == DashboardPage.routeName ||
          currentLocation == GeneratePage.routeName ||
          currentLocation == SettingsPage.routeName ||
          currentLocation == ProfilePage.routeName;

      logger.debug(
          '🚦 redirect: isSplashRoute: $isSplashRoute, isAuthRoute: $isAuthRoute, isProtectedRoute: $isProtectedRoute');

      // Never redirect from splash screen - it handles its own navigation
      if (isSplashRoute) {
        logger.debug('🚦 redirect: On splash screen, no redirect needed');
        return null;
      }

      // Check if user needs to confirm email (from registration flow)
      final needsEmailConfirmation =
          state.uri.queryParameters['needsConfirmation'] == 'true';

      // If not logged in and trying to access protected route, go to login
      if (!isLoggedIn && isProtectedRoute) {
        logger.info(
            '🚦 redirect: Not logged in on protected route, redirecting to login');
        return LoginPage.routeName;
      }

      // If logged in and trying to access auth route, go to home
      // UNLESS user needs to confirm their email
      // CRITICAL: Only redirect from auth routes, never from protected routes.
      // This prevents unwanted redirects when metadata updates trigger auth state changes.
      if (isLoggedIn && isAuthRoute && !needsEmailConfirmation) {
        logger
            .info('🚦 redirect: Logged in on auth route, redirecting to home');
        return DashboardPage.routeName;
      }

      // No redirect - stay on current route
      // This is especially important when user is on a protected route like /profile
      // and their metadata is updated (e.g., avatar upload).
      logger.debug(
          '🚦 redirect: No redirect needed, staying on: $currentLocation');
      return null;
    },

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(context.l10n.errorPrefix(state.error.toString())),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(LoginPage.routeName),
              child: Text(context.l10n.goToLogin),
            ),
          ],
        ),
      ),
    ),
  );
});
