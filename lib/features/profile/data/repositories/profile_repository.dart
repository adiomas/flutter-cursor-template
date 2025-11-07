import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/q_architecture.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/data/supabase_service.dart';
import '../../../../common/utils/logger/app_logger.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/entities/user_entity.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(
    ref.watch(supabaseServiceProvider),
    ref.watch(supabaseClientProvider),
  ),
);

abstract interface class ProfileRepository {
  EitherFailureOr<UserEntity> updateProfile({
    String? displayName,
    String? photoUrl,
  });

  EitherFailureOr<String> uploadAvatar(File imageFile);

  EitherFailureOr<UserEntity> getCurrentProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseService _supabase;
  final SupabaseClient _client;
  final _logger = AppLogger.instance;

  ProfileRepositoryImpl(this._supabase, this._client);

  @override
  EitherFailureOr<UserEntity> getCurrentProfile() async {
    try {
      final user = _supabase.currentUser;
      if (user == null) {
        return Left(Failure.generic(
          error: 'No authenticated user',
        ));
      }

      final userEntity = UserModel.fromSupabaseUser(user).toDomain();
      return Right(userEntity);
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to get current profile',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure.generic(error: e));
    }
  }

  @override
  EitherFailureOr<String> uploadAvatar(File imageFile) async {
    _logger.debug('📤 Starting avatar upload...');

    try {
      // Check if file exists
      if (!await imageFile.exists()) {
        _logger.error(
          '📤 Avatar file does not exist',
          error: 'File path: ${imageFile.path}',
        );
        return Left(Failure.generic(
          error: 'Image file does not exist',
        ));
      }

      final fileSize = await imageFile.length();
      _logger.debug(
          '📤 File size: $fileSize bytes (${(fileSize / 1024).toStringAsFixed(2)} KB)');

      // Check file size limit (5MB)
      const maxSize = 5 * 1024 * 1024; // 5MB
      if (fileSize > maxSize) {
        _logger.error(
          '📤 File too large',
          error: 'File size: $fileSize bytes, Max: $maxSize bytes',
        );
        return Left(Failure.generic(
          error: 'Image file is too large (max 5MB)',
        ));
      }

      final userId = _supabase.currentUserId;
      if (userId == null) {
        _logger.error('📤 No authenticated user found');
        return Left(Failure.generic(
          error: 'No authenticated user',
        ));
      }

      _logger.debug('📤 User ID: $userId');

      // Generate unique filename
      // Note: Do NOT include bucket name in path - bucket is specified in .from('avatars')
      // Path structure: userId/timestamp.jpg (e.g., "abc123/1234567890.jpg")
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$userId/$timestamp.jpg';
      _logger.debug('📤 Generated filename: $fileName');
      _logger.debug('📤 Full path will be: avatars/$fileName');

      // Read file bytes
      _logger.debug('📤 Reading file bytes...');
      final bytes = await imageFile.readAsBytes();
      _logger.debug('📤 File bytes read: ${bytes.length} bytes');

      // Upload to Supabase Storage
      _logger.debug('📤 Uploading to Supabase Storage bucket: avatars');
      _logger.debug('📤 Upload options: cacheControl=3600, upsert=true');

      await _client.storage.from('avatars').uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      _logger.info('✅ File uploaded to storage successfully');

      // Get public URL
      final publicUrl = _client.storage.from('avatars').getPublicUrl(fileName);
      _logger.info('✅ Avatar uploaded successfully: $publicUrl');
      _logger.debug('📤 Public URL generated: $publicUrl');

      return Right(publicUrl);
    } catch (e, stackTrace) {
      _logger.error(
        '❌ Failed to upload avatar',
        error: e,
        stackTrace: stackTrace,
      );
      _logger.debug('📤 Error type: ${e.runtimeType}');
      _logger.debug('📤 Error message: ${e.toString()}');

      // Log additional context if it's a StorageException
      if (e.toString().contains('StorageException') ||
          e.toString().contains('storage') ||
          e.toString().contains('bucket')) {
        _logger.error(
          '📤 Storage-related error detected',
          error: 'This might be a bucket configuration or RLS policy issue',
        );
      }

      return Left(Failure.generic(error: e));
    }
  }

  @override
  EitherFailureOr<UserEntity> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    _logger.debug('📝 Updating profile...');

    try {
      final userId = _supabase.currentUserId;
      if (userId == null) {
        return Left(Failure.generic(
          error: 'No authenticated user',
        ));
      }

      // Build metadata map
      final metadata = <String, dynamic>{};
      if (displayName != null) {
        metadata['display_name'] = displayName;
      }
      if (photoUrl != null) {
        metadata['photo_url'] = photoUrl;
      }

      if (metadata.isEmpty) {
        // Nothing to update, return current user
        return getCurrentProfile();
      }

      // Update user metadata
      final response = await _supabase.updateUserMetadata(metadata);

      if (response.user == null) {
        return Left(Failure.generic(
          error: 'Failed to update profile',
        ));
      }

      final updatedUser = UserModel.fromSupabaseUser(response.user!).toDomain();
      _logger.info('✅ Profile updated successfully');
      return Right(updatedUser);
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to update profile',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure.generic(error: e));
    }
  }
}
