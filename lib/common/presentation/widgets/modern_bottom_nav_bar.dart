import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../presentation/extensions/localization_extension.dart';

/// Ultra-modern bottom navigation bar with blur effects, smooth animations, and elegant design
class ModernBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ModernBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.contentBackground.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(
            color: context.appColors.border.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, -6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, -3),
            spreadRadius: 0,
          ),
          // Highlight shadow to make rounded corners visible
          BoxShadow(
            color: context.appColors.background,
            blurRadius: 0,
            offset: const Offset(0, -1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            top: false,
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    activeIcon: Icons.home_rounded,
                    label: context.l10n.navHome,
                    isActive: currentIndex == 0,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onTap(0);
                    },
                  ),
                  _NavItem(
                    icon: Icons.auto_awesome_outlined,
                    activeIcon: Icons.auto_awesome_rounded,
                    label: context.l10n.navGenerate,
                    isActive: currentIndex == 1,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onTap(1);
                    },
                  ),
                  _NavItem(
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: context.l10n.navProfile,
                    isActive: currentIndex == 2,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onTap(2);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    if (widget.isActive) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Active indicator background
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        width: widget.isActive ? 32 : 0,
                        height: widget.isActive ? 32 : 0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.15),
                              AppColors.primary.withValues(alpha: 0.08),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: widget.isActive
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                    spreadRadius: 0,
                                  ),
                                ]
                              : [],
                        ),
                      ),
                      // Icon with scale animation
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale:
                                widget.isActive ? _scaleAnimation.value : 1.0,
                            child: Icon(
                              widget.isActive ? widget.activeIcon : widget.icon,
                              color: widget.isActive
                                  ? AppColors.primary
                                  : context.appColors.textSecondary.withValues(
                                      alpha: 0.7,
                                    ),
                              size: widget.isActive ? 22 : 20,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 1),
                // Label with fade animation
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: widget.isActive
                        ? AppColors.primary
                        : context.appColors.textSecondary
                            .withValues(alpha: 0.7),
                    fontWeight:
                        widget.isActive ? FontWeight.w700 : FontWeight.w500,
                    fontSize: widget.isActive ? 11 : 10,
                    letterSpacing: widget.isActive ? 0.2 : 0.0,
                    height: 1.0,
                  ),
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      shadows: widget.isActive
                          ? [
                              Shadow(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                blurRadius: 2,
                                offset: const Offset(0, 0),
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper extension to calculate current index from route
extension BottomNavHelper on BuildContext {
  int getBottomNavIndex() {
    final location = GoRouterState.of(this).matchedLocation;
    if (location == '/home' || location == '/dashboard') return 0;
    if (location == '/generate') return 1;
    if (location == '/profile') return 2;
    return 0;
  }

  void navigateToBottomNav(int index) {
    switch (index) {
      case 0:
        go('/home');
        break;
      case 1:
        go('/generate');
        break;
      case 2:
        go('/profile');
        break;
    }
  }
}
