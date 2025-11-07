import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:either_dart/either.dart';
import 'package:q_architecture/q_architecture.dart';

// Mock classes
class MockFeatureRepository extends Mock implements FeatureRepository {}

void main() {
  group('FeatureNotifier Tests', () {
    late ProviderContainer container;
    late MockFeatureRepository mockRepository;
    
    setUp(() {
      mockRepository = MockFeatureRepository();
      container = ProviderContainer(
        overrides: [
          featureRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });
    
    tearDown(() {
      container.dispose();
    });
    
    test('loadFeature sets loading then data state on success', () async {
      // Arrange
      final feature = FeatureEntity(
        id: '1',
        name: 'Test Feature',
        description: 'Test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      when(() => mockRepository.getFeature('1'))
          .thenAnswer((_) async => Right(feature));
      
      // Act
      final notifier = container.read(featureNotifierProvider.notifier);
      await notifier.loadFeature('1');
      
      // Assert
      final state = container.read(featureNotifierProvider);
      expect(state, isA<BaseData<FeatureEntity>>());
      expect((state as BaseData).data.name, 'Test Feature');
    });
    
    test('loadFeature sets error state on failure', () async {
      // Arrange
      when(() => mockRepository.getFeature('1'))
          .thenAnswer((_) async => Left(Failure.notFound(resource: 'Feature')));
      
      // Act
      final notifier = container.read(featureNotifierProvider.notifier);
      await notifier.loadFeature('1');
      
      // Assert
      final state = container.read(featureNotifierProvider);
      expect(state, isA<BaseError<FeatureEntity>>());
    });
    
    test('updateName updates entity in state', () {
      // Arrange
      final feature = FeatureEntity(
        id: '1',
        name: 'Old Name',
        description: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      container.read(featureNotifierProvider.notifier).state = BaseData(feature);
      
      // Act
      container.read(featureNotifierProvider.notifier).updateName('New Name');
      
      // Assert
      final state = container.read(featureNotifierProvider);
      expect((state as BaseData).data.name, 'New Name');
    });
  });
  
  group('FeatureRepository Tests', () {
    late MockSupabaseClient mockClient;
    late FeatureRepository repository;
    
    setUp(() {
      mockClient = MockSupabaseClient();
      repository = FeatureRepositoryImpl(mockClient);
    });
    
    test('getFeatures returns list on success', () async {
      // Arrange
      when(() => mockClient.from('features').select().order(any(), ascending: false))
          .thenAnswer((_) async => [
            {'id': '1', 'name': 'Feature 1', 'created_at': '2024-01-01', 'updated_at': '2024-01-01'},
          ]);
      
      // Act
      final result = await repository.getFeatures();
      
      // Assert
      expect(result.isRight, true);
      expect(result.right.length, 1);
    });
    
    test('getFeature returns failure on error', () async {
      // Arrange
      when(() => mockClient.from('features').select().eq('id', '1').single())
          .thenThrow(Exception('Not found'));
      
      // Act
      final result = await repository.getFeature('1');
      
      // Assert
      expect(result.isLeft, true);
    });
  });
}

