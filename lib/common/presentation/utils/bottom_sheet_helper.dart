import 'package:flutter/material.dart';

/// Helper class for showing bottom sheets that appear above bottom navigation bar
class BottomSheetHelper {
  /// Shows a modal bottom sheet that appears above the bottom navigation bar.
  /// 
  /// This is a wrapper around [showModalBottomSheet] that ensures the bottom sheet
  /// is displayed above all navigation elements, including the bottom navigation bar.
  /// 
  /// Example:
  /// ```dart
  /// await BottomSheetHelper.show(
  ///   context: context,
  ///   builder: (context) => YourBottomSheetContent(),
  /// );
  /// ```
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    Color? backgroundColor,
    ShapeBorder? shape,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useRootNavigator = true,
    bool useSafeArea = true,
    double? elevation,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
    String? barrierLabel,
    Color? barrierColor,
    bool showDragHandle = false,
    BoxConstraints? constraints,
    Clip? clipBehavior,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      backgroundColor: backgroundColor ?? Colors.transparent,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      // CRITICAL: useRootNavigator ensures bottom sheet appears above bottom nav bar
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      elevation: elevation,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      barrierLabel: barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? Colors.black54,
      showDragHandle: showDragHandle,
      constraints: constraints,
      clipBehavior: clipBehavior,
    );
  }
}

