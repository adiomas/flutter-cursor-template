# AI Workflow Examples

Realni primjeri kako AI automatski koristi dokumentaciju za implementaciju.

## Primjer 1: Nova Feature

### Tvoj Input (Jednostavno)

```
Treba mi product reviews feature.
User može ostaviti review (rating 1-5, komentar).
Prikaz prosječnog ratinga i lista reviews.
```

### AI Proces (Automatski)

```
1. Detektira: CRUD feature
   → Čita: docs/07_FEATURE_TEMPLATE.md

2. Database design:
   → Čita: docs/09_DATA_LAYER.md (Supabase patterns)
   → Kreira: 
     CREATE TABLE reviews (
       id UUID PRIMARY KEY,
       product_id UUID REFERENCES products(id),
       user_id UUID REFERENCES users(id),
       rating INT CHECK (rating >= 1 AND rating <= 5),
       comment TEXT,
       created_at TIMESTAMPTZ DEFAULT NOW()
     );

3. Data Layer:
   → Koristi: docs/templates/model_template.dart
   → Kreira: review_model.dart (s JSON serialization)
   → Kreira: review_repository.dart (CRUD methods)

4. Domain Layer:
   → Koristi: docs/templates/entity_template.dart
   → Kreira: review_entity.dart (s business logic)
   → Koristi: docs/templates/notifier_template.dart
   → Kreira: reviews_list_notifier.dart
   → Kreira: review_notifier.dart

5. Presentation Layer:
   → Koristi: docs/templates/page_template.dart
   → Kreira: reviews_page.dart (list view)
   → Kreira: add_review_page.dart (form)
   → Koristi: docs/templates/widget_template.dart
   → Kreira: review_list_item.dart
   → Kreira: rating_stars_widget.dart

6. Error Handling:
   → Čita: docs/06_ERROR_HANDLING.md
   → Dodaje: Either pattern u repository
   → Dodaje: User-friendly error messages
   → Dodaje: Validation (rating 1-5, comment ne smije biti prazan)

7. UI Styling:
   → Čita: docs/11_DESIGN_SYSTEM.md
   → Primjenjuje: AppColors, AppTextStyles, spacing
   → Dodaje: Loading shimmer
   → Dodaje: Empty state

8. Routes:
   → Čita: docs/08_NAVIGATION_SYSTEM.md
   → Dodaje: /reviews i /reviews/add routes

REZULTAT: Kompletan, production-ready reviews feature u ~30 minuta
```

---

## Primjer 2: Bug Fix

### Tvoj Input

```
Kada user nema internet, app crashuje umjesto da prikaže error.
```

### AI Proces

```
1. Detektira: Network error handling issue
   → Čita: docs/26_TROUBLESHOOTING.md (Common Issues)
   → Čita: docs/06_ERROR_HANDLING.md (Error patterns)

2. Analizira:
   → Traži dio koda gdje se radi network request
   → Pronalazi: Repository metode bez try-catch

3. Implementira Fix:
   ```dart
   // BEFORE (crashuje)
   EitherFailureOr<List<Product>> getProducts() async {
     final response = await _client.from('products').select();
     return Right(response.map(...).toList());
   }
   
   // AFTER (handled)
   EitherFailureOr<List<Product>> getProducts() async {
     try {
       final response = await _client.from('products').select();
       return Right(response.map(...).toList());
     } on SocketException {
       return Left(Failure.network(
         message: 'Please check your internet connection'
       ));
     } catch (e) {
       return Left(Failure.generic(error: e));
     }
   }
   ```

4. Update UI:
   → Čita: docs/10_UI_COMPONENT_LIBRARY.md (ErrorView widget)
   → Dodaje: Retry button
   → Dodaje: User-friendly message

5. Testira:
   → Simulira offline mode
   → Verificira da više ne crashuje

REZULTAT: Robust error handling za network issues
```

---

## Primjer 3: Performance Optimizacija

### Tvoj Input

```
Products lista laguje pri scrollanju, imam 500+ proizvoda.
```

### AI Proces

```
1. Detektira: Performance issue s listom
   → Čita: docs/15_PERFORMANCE_OPTIMIZATION.md

2. Analizira Kod:
   ```dart
   // BEFORE (sve loaduje odjednom)
   ListView(
     children: products.map((p) => ProductItem(p)).toList(),
   )
   ```

3. Implementira Optimizacije:
   
   a) ListView.builder:
   ```dart
   ListView.builder(
     itemCount: products.length,
     itemBuilder: (context, index) {
       return ProductItem(
         key: ValueKey(products[index].id),  // Added
         product: products[index],
       );
     },
   )
   ```
   
   b) Const Constructors:
   ```dart
   // BEFORE
   Padding(padding: EdgeInsets.all(16))
   
   // AFTER
   const Padding(padding: EdgeInsets.all(16))
   ```
   
   c) Image Optimization:
   ```dart
   Image.network(
     product.imageUrl,
     cacheWidth: 300,  // Added
     cacheHeight: 300, // Added
   )
   ```
   
   d) RepaintBoundary:
   ```dart
   RepaintBoundary(
     child: ProductItem(product),
   )
   ```

4. Dodaje Pagination:
   → Čita: docs/09_DATA_LAYER.md (Pagination pattern)
   → Implementira: Load 20 items po stranici
   → Dodaje: Infinite scroll

5. Testira:
   → Profile mode
   → Verificira 60 FPS

REZULTAT: Smooth scrolling, optimizirano memory usage
```

---

## Primjer 4: Setup Nova Platforma

### Tvoj Input

```
Kako setup iOS build za TestFlight?
```

### AI Proces

```
1. Detektira: iOS deployment pitanje
   → Čita: docs/20_IOS_CONFIGURATION.md
   → Čita: docs/22_BETA_TESTING.md

2. Provjerava Existing Setup:
   → Provjera ios/Runner.xcworkspace
   → Provjera Bundle ID
   → Provjera Signing

3. Guida Through Steps:
   
   Step 1: Xcode Setup
   - Open ios/Runner.xcworkspace
   - Set Bundle ID: com.yourcompany.app
   - Select Team
   - Enable Automatic Signing
   
   Step 2: Build
   - flutter build ios --release
   - Archive in Xcode (Product → Archive)
   
   Step 3: TestFlight
   - Distribute → App Store Connect
   - Wait for processing
   - Add testers
   - Invite via email

4. Troubleshoots Issues:
   - Signing errors → Regenerate certificates
   - Build errors → Clean & rebuild
   - Upload errors → Check API key

REZULTAT: Successful TestFlight deployment
```

---

## Primjer 5: Refactoring

### Tvoj Input

```
Refaktoriraj Comments feature prema clean architecture.
Trenutno je sve u jednom fajlu - comments_page.dart
```

### AI Proces

```
1. Detektira: Architecture refactoring
   → Čita: docs/04_CLEAN_ARCHITECTURE.md
   → Čita: docs/07_FEATURE_TEMPLATE.md

2. Analizira Existing Code:
   comments_page.dart (650 lines):
   - API calls directly in widget ❌
   - Business logic in UI ❌
   - No error handling ❌
   - No state management ❌

3. Kreira Strukturu:
   features/comments/
   ├── data/
   │   ├── models/
   │   │   └── comment_model.dart  [NEW]
   │   └── repositories/
   │       └── comment_repository.dart  [NEW]
   ├── domain/
   │   ├── entities/
   │   │   └── comment_entity.dart  [NEW]
   │   └── notifiers/
   │       └── comments_notifier.dart  [NEW]
   └── presentation/
       ├── pages/
       │   └── comments_page.dart  [REFACTORED]
       └── widgets/
           └── comment_item.dart  [EXTRACTED]

4. Migrira Kod:
   
   a) Extract Model:
   ```dart
   // comment_model.dart
   @JsonSerializable()
   class CommentModel {
     final String id;
     final String text;
     final String userId;
     
     CommentEntity toDomain() => ...
   }
   ```
   
   b) Create Entity:
   ```dart
   // comment_entity.dart
   class CommentEntity extends Equatable {
     final String id;
     final String text;
     final String userId;
     
     // Business logic
     bool get isLong => text.length > 200;
   }
   ```
   
   c) Create Repository:
   ```dart
   // comment_repository.dart
   abstract interface class CommentRepository {
     EitherFailureOr<List<CommentEntity>> getComments();
   }
   
   class CommentRepositoryImpl implements CommentRepository {
     // Implementation with error handling
   }
   ```
   
   d) Create Notifier:
   ```dart
   // comments_notifier.dart
   class CommentsNotifier extends BaseNotifier<List<CommentEntity>> {
     Future<void> loadComments() async {
       state = const BaseLoading();
       final result = await _repository.getComments();
       state = result.fold(BaseError.new, BaseData.new);
     }
   }
   ```
   
   e) Refactor Page:
   ```dart
   // comments_page.dart (now 150 lines)
   class CommentsPage extends HookConsumerWidget {
     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final state = ref.watch(commentsNotifierProvider);
       
       return switch (state) {
         BaseLoading() => LoadingWidget(),
         BaseData(:final data) => CommentsList(data),
         BaseError(:final failure) => ErrorView(failure),
         _ => SizedBox.shrink(),
       };
     }
   }
   ```

5. Dodaje Što Nedostaje:
   → Error handling (prema 06_ERROR_HANDLING.md)
   → Loading states (prema 05_STATE_MANAGEMENT.md)
   → Proper styling (prema 11_DESIGN_SYSTEM.md)

6. Update Tests:
   → Koristi: docs/templates/test_template.dart
   → Kreira: comment_repository_test.dart
   → Kreira: comments_notifier_test.dart

REZULTAT: Clean, maintainable, testable architecture
```

---

## Primjer 6: Complete Feature from Scratch

### Tvoj Input (Strukturirano)

```yaml
feature: analytics_dashboard
description: Dashboard s key metrics i charts

metrics:
  - total_sales: decimal (this month)
  - new_users: integer (this month)
  - revenue_growth: percentage (vs last month)
  - top_products: list of 5

charts:
  - sales_chart: line chart (last 7 days)
  - category_pie: pie chart (sales by category)

refresh: Pull to refresh, auto-refresh every 5 min
```

### AI Full Implementation

```
1. Čita Dokumentaciju:
   ✓ 07_FEATURE_TEMPLATE.md
   ✓ 09_DATA_LAYER.md (RPC functions)
   ✓ 05_STATE_MANAGEMENT.md (Multiple data sources)
   ✓ 11_DESIGN_SYSTEM.md (Metric cards design)

2. Database:
   → Kreira RPC function:
   CREATE OR REPLACE FUNCTION get_analytics(
     p_user_id UUID
   ) RETURNS JSON AS $$
   -- SQL logic za sve metrics
   $$ LANGUAGE plpgsql;

3. Models & Entities:
   - AnalyticsModel
   - AnalyticsEntity (s getters za formatted values)
   - TopProductEntity

4. Repository:
   - AnalyticsRepository (poziva RPC function)
   - Caching strategija (5 min)

5. Notifier:
   - DashboardNotifier
   - Auto-refresh logic (StreamSubscription)
   - Pull-to-refresh support

6. UI:
   - DashboardPage
   - MetricCard widget (reusable)
   - SalesChart widget (fl_chart integration)
   - CategoryPieChart widget
   - Loading shimmer
   - Error state
   - Empty state

7. Charts Library:
   → Dodaje dependency: fl_chart: ^0.69.0
   → Kreira chart widgets prema library docs

8. Styling:
   → Metric cards s gradientima
   → Icons za svaki metric
   → Responsive grid layout
   → Pull-to-refresh indicator

REZULTAT: Beautiful analytics dashboard, production-ready
```

---

## Zaključak

**AI automatski:**
1. ✅ Prepoznaje tip zahtjeva
2. ✅ Čita relevantnu dokumentaciju
3. ✅ Koristi odgovarajuće template
4. ✅ Slijedi best practices
5. ✅ Implementira kompletan feature

**Ti samo:**
1. Napišeš što trebaš
2. AI radi sve ostalo
3. Review i test

**Jednostavno, brzo, kvalitetno! 🚀**

