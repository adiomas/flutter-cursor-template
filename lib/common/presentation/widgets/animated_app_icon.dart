import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../theme/app_colors.dart';

/// Animated app icon widget with wow effect
/// Features: fade in, scale, pulse, and subtle rotation animations
class AnimatedAppIcon extends HookWidget {
  final double size;
  final Color? color;
  final IconData icon;
  final Duration animationDuration;
  final bool enablePulse;

  const AnimatedAppIcon({
    super.key,
    this.size = 64,
    this.color,
    this.icon = Icons.auto_awesome,
    this.animationDuration = const Duration(milliseconds: 1200),
    this.enablePulse = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? AppColors.primary;

    // Animation controllers
    final mainController = useAnimationController(
      duration: animationDuration,
    );
    final pulseController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
    );

    // Animations
    final fadeAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: mainController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ),
      ),
    );
    final scaleAnimation = useAnimation(
      Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: mainController,
          curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
        ),
      ),
    );
    final rotationAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: mainController,
          curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
        ),
      ),
    );
    final pulseAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 1.12).animate(
        CurvedAnimation(
          parent: pulseController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // Start animations
    useEffect(
      () {
        // Start main animation
        mainController.forward();
        // Start pulse animation (repeating) if enabled
        if (enablePulse) {
          Future.delayed(const Duration(milliseconds: 800), () {
            pulseController.repeat(reverse: true);
          });
        }

        return null;
      },
      [],
    );

    return Transform.scale(
      scale: scaleAnimation * (enablePulse ? pulseAnimation : 1.0),
      child: Transform.rotate(
        angle: (rotationAnimation * 0.15) * math.pi,
        child: Opacity(
          opacity: fadeAnimation,
          child: Icon(
            icon,
            size: size,
            color: iconColor,
            shadows: enablePulse
                ? [
                    BoxShadow(
                      color: iconColor.withOpacity(0.3 * pulseAnimation),
                      blurRadius: 20 * pulseAnimation,
                      spreadRadius: 5 * pulseAnimation,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}

