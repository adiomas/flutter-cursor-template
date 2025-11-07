import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../theme/app_colors.dart';

class AvatarWidget extends HookWidget {
  final String? photoUrl;
  final String initials;
  final VoidCallback onTap;
  final double size;
  final bool isLoading;

  const AvatarWidget({
    super.key,
    this.photoUrl,
    required this.initials,
    required this.onTap,
    this.size = 120,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Animation controllers
    final mainController = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );
    final pulseController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
    );
    final cameraController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
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
      Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: mainController,
          curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
        ),
      ),
    );
    final shadowAnimation = useAnimation(
      Tween<double>(begin: 0.3, end: 0.5).animate(
        CurvedAnimation(
          parent: pulseController,
          curve: Curves.easeInOut,
        ),
      ),
    );
    final pulseScaleAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(
          parent: pulseController,
          curve: Curves.easeInOut,
        ),
      ),
    );
    final cameraRotationAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: cameraController,
          curve: Curves.easeInOut,
        ),
      ),
    );
    final cameraScaleAnimation = useAnimation(
      Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: cameraController,
          curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
        ),
      ),
    );

    // Start animations
    useEffect(
      () {
        // Start main animation
        mainController.forward();
        // Start pulse animation (repeating)
        Future.delayed(const Duration(milliseconds: 600), () {
          pulseController.repeat(reverse: true);
        });
        // Start camera icon animation with delay
        Future.delayed(const Duration(milliseconds: 400), () {
          cameraController.forward();
        });

        return null;
      },
      [],
    );

    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: scaleAnimation * pulseScaleAnimation,
        child: Opacity(
          opacity: fadeAnimation,
          child: Stack(
            children: [
              // Main avatar container
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.appColors.primary,
                      context.appColors.secondary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.appColors.primary
                          .withOpacity(shadowAnimation),
                      blurRadius: 25 * pulseScaleAnimation,
                      spreadRadius: 5 * pulseScaleAnimation,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : photoUrl != null && photoUrl!.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: photoUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  _buildInitials(context, initials),
                            ),
                          )
                        : _buildInitials(context, initials),
              ),
              // Animated camera icon
              Positioned(
                bottom: 0,
                right: 0,
                child: Transform.scale(
                  scale: cameraScaleAnimation,
                  child: Transform.rotate(
                    angle: (cameraRotationAnimation * 0.1) * math.pi,
                    child: Container(
                      width: size * 0.3,
                      height: size * 0.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.appColors.primary,
                        border: Border.all(
                          color: context.appColors.contentBackground,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.appColors.primary
                                .withOpacity(0.4 * cameraScaleAnimation),
                            blurRadius: 10 * cameraScaleAnimation,
                            spreadRadius: 2 * cameraScaleAnimation,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: size * 0.15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitials(BuildContext context, String initials) {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
