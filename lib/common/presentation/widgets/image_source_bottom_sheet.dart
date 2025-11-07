import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../utils/logger/app_logger.dart';
import '../extensions/localization_extension.dart';
import '../spacing.dart';
import '../utils/bottom_sheet_helper.dart';

/// Reusable bottom sheet for selecting image source (Gallery or Camera)
class ImageSourceBottomSheet extends StatelessWidget {
  const ImageSourceBottomSheet({super.key});

  /// Shows the image source selection bottom sheet
  ///
  /// Returns [ImageSource?] - the selected source, or null if cancelled
  static Future<ImageSource?> show(BuildContext context) {
    final logger = AppLogger.instance;
    logger.debug('📷 Showing image source bottom sheet...');

    return BottomSheetHelper.show<ImageSource>(
      context: context,
      backgroundColor: context.appColors.contentBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ImageSourceBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger.instance;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: paddingAll16,
            child: Text(
              context.l10n.profileSelectAvatarSource,
              style: context.textStyles.titleMedium,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(context.l10n.profileSelectFromGallery),
            onTap: () {
              logger.debug('📷 User selected: Gallery');
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(context.l10n.profileTakePhoto),
            onTap: () {
              logger.debug('📷 User selected: Camera');
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          spacing16,
        ],
      ),
    );
  }
}
