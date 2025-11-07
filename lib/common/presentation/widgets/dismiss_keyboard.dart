import 'package:flutter/material.dart';

/// A widget that dismisses the keyboard when the user taps anywhere on the screen.
/// 
/// Wrap your content with this widget to enable keyboard dismissal on tap.
/// This is useful for forms and pages with text input fields.
/// 
/// Example:
/// ```dart
/// DismissKeyboard(
///   child: Scaffold(
///     body: YourContent(),
///   ),
/// )
/// ```
class DismissKeyboard extends StatelessWidget {
  final Widget child;

  const DismissKeyboard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard by removing focus from any focused node
        FocusScope.of(context).unfocus();
      },
      // Don't intercept taps on interactive widgets (buttons, text fields, etc.)
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}

