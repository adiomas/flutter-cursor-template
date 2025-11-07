import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  
  const LoadingIndicator({
    super.key,
    this.size = 24,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  final String? message;
  
  const LoadingScreen({super.key, this.message});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LoadingIndicator(size: 48),
            if (message != null) ...[
              const SizedBox(height: 24),
              Text(
                message!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

