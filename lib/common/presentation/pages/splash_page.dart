import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../features/auth/domain/notifiers/auth_notifier.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../theme/app_colors.dart';
import '../../utils/logger/app_logger.dart';

/// Splash screen page that displays for 3 seconds before navigating
/// to the appropriate route based on authentication status.
class SplashPage extends HookConsumerWidget {
  static const routeName = '/splash';
  static const Duration splashDuration = Duration(seconds: 3);

  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = AppLogger.instance;
    final authState = ref.watch(authNotifierProvider);

    // Animation controllers
    final logoController = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );
    final textController = useAnimationController(
      duration: const Duration(milliseconds: 800),
    );
    final pulseController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );
    final gradientController = useAnimationController(
      duration: const Duration(milliseconds: 3000),
    );

    // Animations
    final logoFadeAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: logoController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ),
      ),
    );
    final logoScaleAnimation = useAnimation(
      Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: logoController,
          curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
        ),
      ),
    );
    final logoRotationAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: logoController,
          curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
        ),
      ),
    );
    final textFadeAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: textController,
          curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
        ),
      ),
    );
    final textSlideAnimation = useAnimation(
      Tween<double>(begin: 30.0, end: 0.0).animate(
        CurvedAnimation(
          parent: textController,
          curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
        ),
      ),
    );
    final pulseAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(
          parent: pulseController,
          curve: Curves.easeInOut,
        ),
      ),
    );
    final gradientAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: gradientController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // Start animations
    useEffect(
      () {
        // Start logo animation
        logoController.forward();
        // Start text animation with delay
        Future.delayed(const Duration(milliseconds: 400), () {
          textController.forward();
        });
        // Start pulse animation (repeating)
        pulseController.repeat(reverse: true);
        // Start gradient animation (repeating)
        gradientController.repeat();

        return null;
      },
      [],
    );

    useEffect(
      () {
        logger.info('🚀 SplashPage: Starting splash screen timer');
        final timer = Timer(splashDuration, () {
          if (!context.mounted) {
            logger.warning(
                '🚀 SplashPage: Context not mounted, skipping navigation');
            return;
          }

          logger.info('🚀 SplashPage: Timer completed, navigating...');

          // Check auth status and navigate accordingly
          final isLoggedIn = authState.maybeWhen(
            data: (user) => user != null,
            orElse: () => false,
          );

          if (isLoggedIn) {
            logger.info(
                '🚀 SplashPage: User is logged in, navigating to dashboard');
            context.go(DashboardPage.routeName);
          } else {
            logger.info(
                '🚀 SplashPage: User is not logged in, navigating to login');
            context.go(LoginPage.routeName);
          }
        });

        return () {
          logger.debug('🚀 SplashPage: Cleaning up timer');
          timer.cancel();
        };
      },
      [],
    );

    return Scaffold(
      body: AnimatedBuilder(
        animation: gradientController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                  Color.lerp(
                    AppColors.primary,
                    Colors.purple.shade400,
                    (math.sin(gradientAnimation * 2 * math.pi) + 1) / 2,
                  )!,
                  AppColors.primary,
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo with multiple effects
                    Transform.scale(
                      scale: logoScaleAnimation * pulseAnimation,
                      child: Transform.rotate(
                        angle: (logoRotationAnimation * 0.1) * math.pi,
                        child: Opacity(
                          opacity: logoFadeAnimation,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 30 * pulseAnimation,
                                  spreadRadius: 10 * pulseAnimation,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              size: 64,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Animated App Name
                    Opacity(
                      opacity: textFadeAnimation,
                      child: Transform.translate(
                        offset: Offset(0, textSlideAnimation),
                        child: Text(
                          'Glow AI',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Subtle shimmer effect
                    Opacity(
                      opacity: textFadeAnimation * 0.7,
                      child: Transform.translate(
                        offset: Offset(0, textSlideAnimation),
                        child: Text(
                          'Illuminate Your Ideas',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 1.0,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
