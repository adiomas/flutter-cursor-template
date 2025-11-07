import 'package:equatable/equatable.dart';

class FeatureEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const FeatureEntity({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
  
  // Business logic methods
  bool get hasDescription => description != null && description!.isNotEmpty;
  
  bool get isNew {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    return diff.inDays < 7;
  }
  
  // For empty/new entity
  factory FeatureEntity.empty() {
    final now = DateTime.now();
    return FeatureEntity(
      id: '',
      name: '',
      description: null,
      createdAt: now,
      updatedAt: now,
    );
  }
  
  // Immutable copy
  FeatureEntity copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FeatureEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [id, name, description, createdAt, updatedAt];
}

