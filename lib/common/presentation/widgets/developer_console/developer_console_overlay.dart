import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

import '../../../domain/app_environment.dart';
import '../../../domain/navigator_key.dart';
import '../../utils/bottom_sheet_helper.dart';
import 'developer_console_modal.dart';

/// Overlay that listens for shake gestures and shows developer console
class DeveloperConsoleOverlay extends StatefulWidget {
  final Widget child;

  const DeveloperConsoleOverlay({
    super.key,
    required this.child,
  });

  @override
  State<DeveloperConsoleOverlay> createState() =>
      _DeveloperConsoleOverlayState();
}

class _DeveloperConsoleOverlayState extends State<DeveloperConsoleOverlay> {
  ShakeDetector? _shakeDetector;

  @override
  void initState() {
    super.initState();
    _initShakeDetector();
  }

  void _initShakeDetector() {
    // Only enable shake detection in dev and staging
    if (EnvInfo.isDevelopment || EnvInfo.isStaging) {
      _shakeDetector = ShakeDetector.autoStart(
        onPhoneShake: _showDeveloperConsole,
        minimumShakeCount: 1,
        shakeSlopTimeMS: 500,
        shakeCountResetTime: 3000,
        shakeThresholdGravity: 2.7,
      );
    }
  }

  void _showDeveloperConsole(ShakeEvent event) {
    // Show the developer console modal
    if (!mounted) return;

    // Use the global navigator key to get the Navigator context
    // This ensures we have access to MaterialLocalizations
    final navigatorState = navigatorKey.currentState;
    if (navigatorState == null || !navigatorState.mounted) return;

    final navigatorContext = navigatorState.context;

    BottomSheetHelper.show(
      context: navigatorContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DeveloperConsoleModal(),
    );
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
