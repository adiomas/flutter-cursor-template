import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/domain/base_state.dart';
import '../../../../common/utils/logger/app_logger.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../data/repositories/profile_repository.dart';

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, BaseState<UserEntity>>(
  (ref) => ProfileNotifier(ref),
);

class ProfileNotifier extends StateNotifier<BaseState<UserEntity>> {
  final Ref ref;
  late ProfileRepository _repository;
  final _logger = AppLogger.instance;

  ProfileNotifier(this.ref) : super(const BaseInitial()) {
    _repository = ref.read(profileRepositoryProvider);
  }

  Future<void> loadProfile() async {
    _logger.debug('📋 Loading profile...');
    state = const BaseLoading();

    final result = await _repository.getCurrentProfile();
    state = result.fold(
      (failure) => BaseError(failure),
      (user) => BaseData(user),
    );
  }

  Future<bool> updateDisplayName(String displayName) async {
    if (displayName.trim().isEmpty) {
      return false;
    }

    state = const BaseLoading();

    final result = await _repository.updateProfile(
      displayName: displayName.trim(),
    );

    return result.fold(
      (failure) {
        state = BaseError(failure);
        return false;
      },
      (updatedUser) {
        state = BaseData(updatedUser);
        return true;
      },
    );
  }

  Future<bool> uploadAvatar(File imageFile) async {
    _logger.debug('📤 ProfileNotifier: Starting avatar upload...');
    _logger.debug('📤 File path: ${imageFile.path}');

    state = const BaseLoading();
    _logger.debug('📤 State set to BaseLoading');

    // First upload the image
    _logger.debug('📤 Calling repository.uploadAvatar()...');
    final uploadResult = await _repository.uploadAvatar(imageFile);

    return uploadResult.fold(
      (failure) {
        _logger.error(
          '❌ ProfileNotifier: Avatar upload failed',
          error: failure.error,
        );
        _logger.debug('📤 Failure type: ${failure.runtimeType}');
        state = BaseError(failure);
        return false;
      },
      (photoUrl) async {
        _logger.info('✅ ProfileNotifier: Avatar uploaded, URL: $photoUrl');
        _logger.debug('📤 Now updating profile with photo URL...');

        // Then update profile with photo URL
        final updateResult = await _repository.updateProfile(
          photoUrl: photoUrl,
        );

        return updateResult.fold(
          (failure) {
            _logger.error(
              '❌ ProfileNotifier: Failed to update profile with photo URL',
              error: failure.error,
            );
            state = BaseError(failure);
            return false;
          },
          (updatedUser) {
            _logger.info('✅ ProfileNotifier: Profile updated successfully');
            _logger.debug('📤 Updated user ID: ${updatedUser.id}');
            _logger.debug('📤 Updated photo URL: ${updatedUser.photoUrl}');
            state = BaseData(updatedUser);
            return true;
          },
        );
      },
    );
  }

  void updateLocalDisplayName(String displayName) {
    final currentState = state;
    if (currentState is BaseData<UserEntity>) {
      state = BaseData(
        currentState.value.copyWith(displayName: displayName),
      );
    }
  }
}
