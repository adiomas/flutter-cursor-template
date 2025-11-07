import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:q_architecture/q_architecture.dart';

import '../../utils/logger/app_logger.dart';

/// Service for handling image picking operations
class ImagePickerService {
  static const int defaultMaxWidth = 1024;
  static const int defaultMaxHeight = 1024;
  static const int defaultQuality = 85;

  final ImagePicker _picker = ImagePicker();
  final AppLogger _logger = AppLogger.instance;

  /// Picks an image from the specified source
  ///
  /// Returns [Either<Failure, File>] where:
  /// - [Left] contains a [Failure] if picking failed
  /// - [Right] contains the selected [File] if successful
  Future<Either<Failure, File>> pickImage({
    required ImageSource source,
    int maxWidth = defaultMaxWidth,
    int maxHeight = defaultMaxHeight,
    int quality = defaultQuality,
  }) async {
    try {
      _logger.debug(
        '📷 Picking image from ${source == ImageSource.gallery ? "Gallery" : "Camera"}',
      );
      _logger.debug(
        '📷 Image picker settings: maxWidth=$maxWidth, maxHeight=$maxHeight, quality=$quality',
      );

      XFile? image;
      try {
        image = await _picker.pickImage(
          source: source,
          maxWidth: maxWidth.toDouble(),
          maxHeight: maxHeight.toDouble(),
          imageQuality: quality,
        );
      } on PlatformException catch (e, stackTrace) {
        _logger.error(
          '❌ PlatformException during image pick',
          error: e,
          stackTrace: stackTrace,
        );

        // Check for permission errors
        if (e.code == 'photo_access_denied' ||
            e.code == 'camera_access_denied' ||
            e.message?.toLowerCase().contains('permission') == true) {
          return Left(Failure.generic(
            error: 'permission_denied',
          ));
        }

        return Left(Failure.generic(
          error: e,
          stackTrace: stackTrace,
        ));
      }

      if (image == null) {
        _logger.debug('📷 User cancelled image selection');
        return Left(Failure.generic(
          error: 'user_cancelled',
        ));
      }

      _logger.info('✅ Image picked successfully: ${image.path}');
      _logger.debug(
        '📷 Image details: name=${image.name}, size=${image.length} bytes',
      );

      final file = File(image.path);

      // Validate file exists
      if (!await file.exists()) {
        _logger.error(
          '📷 Selected image file does not exist',
          error: 'File path: ${image.path}',
        );
        return Left(Failure.generic(
          error: 'file_not_found',
        ));
      }

      final fileSize = await file.length();
      _logger.debug(
        '📷 File size: $fileSize bytes (${(fileSize / 1024).toStringAsFixed(2)} KB)',
      );

      return Right(file);
    } catch (e, stackTrace) {
      _logger.error(
        '❌ Unexpected error during image pick',
        error: e,
        stackTrace: stackTrace,
      );

      // Check for permission errors in error message
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('permission') ||
          errorString.contains('denied')) {
        return Left(Failure.generic(
          error: 'permission_denied',
        ));
      }

      return Left(Failure.generic(
        error: e,
        stackTrace: stackTrace,
      ));
    }
  }
}

/// Provider for ImagePickerService
final imagePickerServiceProvider = Provider<ImagePickerService>(
  (ref) => ImagePickerService(),
);
