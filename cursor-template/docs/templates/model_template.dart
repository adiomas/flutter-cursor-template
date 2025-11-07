import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/feature_entity.dart';

part 'feature_model.g.dart';

@JsonSerializable()
class FeatureModel {
  final String id;
  final String name;
  final String? description;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  
  const FeatureModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
  
  // JSON serialization
  factory FeatureModel.fromJson(Map<String, dynamic> json) =>
      _$FeatureModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$FeatureModelToJson(this);
  
  // Convert to domain entity
  FeatureEntity toDomain() {
    return FeatureEntity(
      id: id,
      name: name,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  
  // Create from domain entity (for updates)
  factory FeatureModel.fromDomain(FeatureEntity entity) {
    return FeatureModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

// Run: dart run build_runner build --delete-conflicting-outputs

