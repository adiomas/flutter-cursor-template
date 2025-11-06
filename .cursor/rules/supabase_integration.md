---
description: Supabase integration patterns for data persistence
globs:
  - lib/features/**/repositories/*.dart
  - lib/features/**/models/*.dart
alwaysApply: false
---

# Supabase Integration Rules

## Context7 Auto-Load

When working with repositories/models, automatically load:
```
@Docs Supabase Flutter client
@Docs Supabase database operations
@Docs Supabase error handling
```

Dynamic loading based on operation:
```
if (auth operation) → @Docs Supabase authentication
if (realtime) → @Docs Supabase realtime subscriptions
if (storage) → @Docs Supabase storage operations
if (RPC) → @Docs Supabase edge functions
```

---

Auto-applies when working with repository or model files.

## Repository Patterns

### Basic CRUD

```dart
class FeatureRepository {
  final SupabaseClient _client;
  
  FeatureRepository(this._client);
  
  // GET ALL
  Future<Either<Failure, List<Entity>>> getAll() async {
    try {
      final response = await _client
        .from('table_name')
        .select()
        .order('created_at', ascending: false);
        
      return Right(
        response.map((json) => Model.fromJson(json).toDomain()).toList()
      );
    } catch (e) {
      return Left(Failure('Greška pri dohvaćanju podataka: ${e.toString()}'));
    }
  }
  
  // GET BY ID
  Future<Either<Failure, Entity>> getById(String id) async {
    try {
      final response = await _client
        .from('table_name')
        .select()
        .eq('id', id)
        .single();
        
      return Right(Model.fromJson(response).toDomain());
    } catch (e) {
      return Left(Failure('Zapis nije pronađen'));
    }
  }
  
  // CREATE
  Future<Either<Failure, Entity>> create(Entity entity) async {
    try {
      final model = Model.fromDomain(entity);
      final response = await _client
        .from('table_name')
        .insert(model.toJson())
        .select()
        .single();
        
      return Right(Model.fromJson(response).toDomain());
    } catch (e) {
      return Left(Failure('Greška pri spremanju: ${e.toString()}'));
    }
  }
  
  // UPDATE
  Future<Either<Failure, Entity>> update(String id, Entity entity) async {
    try {
      final model = Model.fromDomain(entity);
      final response = await _client
        .from('table_name')
        .update(model.toJson())
        .eq('id', id)
        .select()
        .single();
        
      return Right(Model.fromJson(response).toDomain());
    } catch (e) {
      return Left(Failure('Greška pri ažuriranju: ${e.toString()}'));
    }
  }
  
  // DELETE
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await _client
        .from('table_name')
        .delete()
        .eq('id', id);
        
      return const Right(null);
    } catch (e) {
      return Left(Failure('Greška pri brisanju: ${e.toString()}'));
    }
  }
}
```

### With Filtering & Search

```dart
Future<Either<Failure, List<Entity>>> search({
  String? query,
  String? category,
  int limit = 20,
  int offset = 0,
}) async {
  try {
    var request = _client
      .from('table_name')
      .select()
      .range(offset, offset + limit - 1);
    
    if (query != null && query.isNotEmpty) {
      request = request.ilike('name', '%$query%');
    }
    
    if (category != null) {
      request = request.eq('category_id', category);
    }
    
    final response = await request.order('created_at', ascending: false);
    
    return Right(
      response.map((json) => Model.fromJson(json).toDomain()).toList()
    );
  } catch (e) {
    return Left(Failure('Greška pri pretraživanju: ${e.toString()}'));
  }
}
```

### Realtime Subscriptions

```dart
Stream<Either<Failure, List<Entity>>> watchAll() {
  return _client
    .from('table_name')
    .stream(primaryKey: ['id'])
    .order('created_at', ascending: false)
    .map((data) => Right(
      data.map((json) => Model.fromJson(json).toDomain()).toList()
    ))
    .handleError((error) => Left(Failure(error.toString())));
}
```

### File Upload (Supabase Storage)

```dart
Future<Either<Failure, String>> uploadImage(File file, String path) async {
  try {
    final String fullPath = 'images/$path/${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    await _client.storage
      .from('bucket_name')
      .upload(fullPath, file);
    
    final String publicUrl = _client.storage
      .from('bucket_name')
      .getPublicUrl(fullPath);
    
    return Right(publicUrl);
  } catch (e) {
    return Left(Failure('Greška pri uploadu slike: ${e.toString()}'));
  }
}
```

### RPC Calls

```dart
Future<Either<Failure, Map<String, dynamic>>> callRPC(String functionName, Map<String, dynamic> params) async {
  try {
    final response = await _client.rpc(functionName, params: params);
    return Right(response as Map<String, dynamic>);
  } catch (e) {
    return Left(Failure('RPC greška: ${e.toString()}'));
  }
}
```

## Model Patterns

```dart
@JsonSerializable()
class FeatureModel {
  final String id;
  final String name;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  
  FeatureModel({
    required this.id,
    required this.name,
    required this.createdAt,
    this.updatedAt,
  });
  
  factory FeatureModel.fromJson(Map<String, dynamic> json) =>
    _$FeatureModelFromJson(json);
    
  Map<String, dynamic> toJson() => _$FeatureModelToJson(this);
  
  FeatureEntity toDomain() => FeatureEntity(
    id: id,
    name: name,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  factory FeatureModel.fromDomain(FeatureEntity entity) => FeatureModel(
    id: entity.id,
    name: entity.name,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
```

## Error Handling

Always wrap in try-catch and return user-friendly Croatian messages:

```dart
try {
  // Supabase operation
} on PostgrestException catch (e) {
  return Left(Failure('Greška s bazom podataka: ${e.message}'));
} on StorageException catch (e) {
  return Left(Failure('Greška pri spremanju datoteke: ${e.message}'));
} catch (e) {
  return Left(Failure('Nepoznata greška: ${e.toString()}'));
}
```

## RLS Policies

Always consider Row Level Security when designing queries:

```sql
-- Enable RLS
ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;

-- Policy for authenticated users
CREATE POLICY "Users can view their own data"
ON table_name FOR SELECT
USING (auth.uid() = user_id);

-- Policy for public read
CREATE POLICY "Public can read"
ON table_name FOR SELECT
USING (true);
```

@docs/09_DATA_LAYER.md
@docs/templates/repository_template.dart
@docs/templates/model_template.dart

