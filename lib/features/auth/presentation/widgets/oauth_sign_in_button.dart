import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

/// Modern OAuth sign-in button widget
/// Supports Google and Apple sign-in with platform-specific styling
class OAuthSignInButton extends StatelessWidget {
  final OAuthProvider provider;
  final VoidCallback? onPressed;
  final bool isLoading;

  const OAuthSignInButton({
    super.key,
    required this.provider,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isGoogle = provider == OAuthProvider.google;
    final isApple = provider == OAuthProvider.apple;

    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: context.appColors.contentBackground,
          foregroundColor: context.appColors.textPrimary,
          side: BorderSide(
            color: context.appColors.border,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.appColors.primary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isGoogle) ...[
                    // Google "G" icon - using custom widget
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: CustomPaint(
                        painter: GoogleIconPainter(),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ] else if (isApple) ...[
                    // Apple logo icon
                    Icon(
                      Icons.apple,
                      size: 20,
                      color: context.appColors.textPrimary,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    isGoogle
                        ? context.l10n.authSignInWithGoogle
                        : context.l10n.authSignInWithApple,
                    style: context.textStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Custom painter for Google "G" icon
/// Draws a simplified Google "G" logo
class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Google "G" colors
    final blue = Paint()..color = const Color(0xFF4285F4);
    final red = Paint()..color = const Color(0xFFEA4335);
    final yellow = Paint()..color = const Color(0xFFFBBC05);
    final green = Paint()..color = const Color(0xFF34A853);

    // Draw simplified Google "G" - using a circle with a cutout
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw colored segments to represent Google logo
    // This is a simplified version - in production, use an actual asset
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw blue arc (top right)
    canvas.drawArc(
      rect,
      -1.57, // -90 degrees
      1.57, // 90 degrees
      false,
      blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.3,
    );

    // Draw red arc (top left)
    canvas.drawArc(
      rect,
      3.14, // 180 degrees
      1.57, // 90 degrees
      false,
      red
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.3,
    );

    // Draw yellow arc (bottom left)
    canvas.drawArc(
      rect,
      1.57, // 90 degrees
      1.57, // 90 degrees
      false,
      yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.3,
    );

    // Draw green arc (bottom right)
    canvas.drawArc(
      rect,
      0, // 0 degrees
      1.57, // 90 degrees
      false,
      green
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum OAuthProvider {
  google,
  apple,
}

/// Platform check helper for OAuth providers
class OAuthPlatformHelper {
  /// Check if Apple Sign In is available (iOS/macOS only)
  static bool get isAppleSignInAvailable {
    return Platform.isIOS || Platform.isMacOS;
  }

  /// Check if Google Sign In is available (all platforms)
  static bool get isGoogleSignInAvailable => true;
}
