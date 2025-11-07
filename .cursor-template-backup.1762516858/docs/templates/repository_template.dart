import 'package:either_dart/either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/q_architecture.dart';
import '../../../common/data/supabase_service.dart';
import '../../domain/entities/feature_entity.dart';
import '../models/feature_model.dart';

// Provider for dependency injection
final featureRepositoryProvider = Provider<FeatureRepository>(
  (ref) => FeatureRepositoryImpl(
    ref.watch(supabaseServiceProvider),
  ),
);

// Repository interface
abstract interface class FeatureRepository {
  EitherFailureOr<List<FeatureEntity>> getFeatures();
  EitherFailureOr<FeatureEntity> getFeature(String id);
  EitherFailureOr<FeatureEntity> createFeature(FeatureEntity feature);
  EitherFailureOr<FeatureEntity> updateFeature(FeatureEntity feature);
  EitherFailureOr<void> deleteFeature(String id);
}

// Repository implementation
class FeatureRepositoryImpl implements FeatureRepository {
  final SupabaseService _supabase;
  
  FeatureRepositoryImpl(this._supabase);
  
  @override
  EitherFailureOr<List<FeatureEntity>> getFeatures() async {
    try {
      final response = await _supabase.client
          .from('features')
          .select()
          .order('created_at', ascending: false);
      
      final features = (response as List)
          .map((json) => FeatureModel.fromJson(json).toDomain())
          .toList();
      
      return Right(features);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
  
  @override
  EitherFailureOr<FeatureEntity> getFeature(String id) async {
    try {
      final response = await _supabase.client
          .from('features')
          .select()
          .eq('id', id)
          .single();
      
      final feature = FeatureModel.fromJson(response).toDomain();
      return Right(feature);
    } catch (e) {
      return Left(Failure.notFound(resource: 'Feature'));
    }
  }
  
  @override
  EitherFailureOr<FeatureEntity> createFeature(FeatureEntity feature) async {
    try {
      final model = FeatureModel.fromDomain(feature);
      final response = await _supabase.client
          .from('features')
          .insert(model.toJson())
          .select()
          .single();
      
      final createdFeature = FeatureModel.fromJson(response).toDomain();
      return Right(createdFeature);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
  
  @override
  EitherFailureOr<FeatureEntity> updateFeature(FeatureEntity feature) async {
    try {
      final model = FeatureModel.fromDomain(feature);
      final response = await _supabase.client
          .from('features')
          .update(model.toJson())
          .eq('id', feature.id)
          .select()
          .single();
      
      final updatedFeature = FeatureModel.fromJson(response).toDomain();
      return Right(updatedFeature);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
  
  @override
  EitherFailureOr<void> deleteFeature(String id) async {
    try {
      await _supabase.client
          .from('features')
          .delete()
          .eq('id', id);
      
      return const Right(null);
    } catch (e) {
      return Left(Failure.generic(error: e));
    }
  }
}

