import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/q_architecture.dart';
import '../../data/repositories/feature_repository.dart';
import '../entities/feature_entity.dart';

// List Notifier Provider
final featuresListNotifierProvider =
    NotifierProvider<FeaturesListNotifier, BaseState<List<FeatureEntity>>>(
  () => FeaturesListNotifier(),
);

class FeaturesListNotifier extends BaseNotifier<List<FeatureEntity>> {
  late FeatureRepository _repository;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(featureRepositoryProvider);
  }
  
  Future<void> loadFeatures() async {
    state = const BaseLoading();
    final result = await _repository.getFeatures();
    state = result.fold(
      BaseError.new,
      (features) {
        // Apply business logic
        features.sort((a, b) => a.name.compareTo(b.name));
        return BaseData(features);
      },
    );
  }
  
  Future<void> deleteFeature(String id) async {
    state = const BaseLoading();
    final result = await _repository.deleteFeature(id);
    
    result.fold(
      (failure) {
        state = BaseError(failure);
        ref.read(snackbarProvider).showError(failure.userMessage);
      },
      (_) {
        // Note: Use l10n from context when showing snackbar
        // ref.read(snackbarProvider).showSuccess(context.l10n.successDeleted);
        loadFeatures();
      },
    );
  }
}

// Single Item Notifier Provider
final featureNotifierProvider =
    NotifierProvider<FeatureNotifier, BaseState<FeatureEntity>>(
  () => FeatureNotifier(),
);

class FeatureNotifier extends BaseNotifier<FeatureEntity> {
  late FeatureRepository _repository;
  
  @override
  void prepareForBuild() {
    _repository = ref.watch(featureRepositoryProvider);
  }
  
  void initializeNew() {
    state = BaseData(FeatureEntity.empty());
  }
  
  Future<void> loadFeature(String id) async {
    state = const BaseLoading();
    final result = await _repository.getFeature(id);
    state = result.fold(BaseError.new, BaseData.new);
  }
  
  void updateName(String name) {
    final feature = state.dataOrNull;
    if (feature == null) return;
    
    state = BaseData(feature.copyWith(name: name));
  }
  
  Future<bool> saveFeature() async {
    final feature = state.dataOrNull;
    if (feature == null) return false;
    
    // Validation
    if (feature.name.trim().isEmpty) {
      // Note: Use l10n from context when showing snackbar
      // ref.read(snackbarProvider).showError(context.l10n.validationRequired);
      return false;
    }
    
    state = const BaseLoading();
    
    final result = feature.id.isEmpty
        ? await _repository.createFeature(feature)
        : await _repository.updateFeature(feature);
    
    return result.fold(
      (failure) {
        state = BaseError(failure);
        ref.read(snackbarProvider).showError(failure.userMessage);
        return false;
      },
      (savedFeature) {
        state = BaseData(savedFeature);
        // Note: Use l10n from context when showing snackbar
        // final message = feature.id.isEmpty 
        //   ? context.l10n.successCreated 
        //   : context.l10n.successUpdated;
        // ref.read(snackbarProvider).showSuccess(message);
        
        // Refresh list
        ref.invalidate(featuresListNotifierProvider);
        return true;
      },
    );
  }
}

