import 'package:flutter/material.dart';

/// Global navigator key for accessing Navigator from anywhere
/// This is used by DeveloperConsoleOverlay to show modals with proper
/// MaterialLocalizations context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

