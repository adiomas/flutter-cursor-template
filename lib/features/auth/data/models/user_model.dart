import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
  });

  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email!,
      displayName: user.userMetadata?['display_name'] as String?,
      photoUrl: user.userMetadata?['photo_url'] as String?,
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  UserEntity toDomain() {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      createdAt: createdAt,
    );
  }
}
