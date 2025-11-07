# Testing Strategy

Comprehensive testing approach - unit, widget, integration, and E2E tests for reliable code.

## Test Pyramid

```
      /\
     /E2E\          10% - End-to-end tests
    /------\
   /Widget \        30% - Widget tests
  /----------\
 /  Unit      \     60% - Unit tests
/--------------\
```

## Unit Testing

### Repository Tests

```dart
void main() {
  late MockSupabaseClient mockClient;
  late UserRepository repository;
  
  setUp(() {
    mockClient = MockSupabaseClient();
    repository = UserRepositoryImpl(mockClient);
  });
  
  test('getUser returns user on success', () async {
    when(() => mockClient.from('users').select().eq('id', '1').single())
        .thenAnswer((_) async => {'id': '1', 'name': 'Test'});
    
    final result = await repository.getUser('1');
    
    expect(result.isRight, true);
    expect(result.right.name, 'Test');
  });
  
  test('getUser returns failure on error', () async {
    when(() => mockClient.from('users').select().eq('id', '1').single())
        .thenThrow(Exception('Not found'));
    
    final result = await repository.getUser('1');
    
    expect(result.isLeft, true);
  });
}
```

### Notifier Tests

```dart
void main() {
  late ProviderContainer container;
  late MockUserRepository mockRepository;
  
  setUp(() {
    mockRepository = MockUserRepository();
    container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });
  
  tearDown(() => container.dispose());
  
  test('loadUser sets loading then data state', () async {
    final user = User(id: '1', name: 'Test');
    when(() => mockRepository.getUser('1'))
        .thenAnswer((_) async => Right(user));
    
    final notifier = container.read(userNotifierProvider.notifier);
    
    expect(container.read(userNotifierProvider), isA<BaseInitial>());
    
    await notifier.loadUser('1');
    
    final state = container.read(userNotifierProvider);
    expect(state, isA<BaseData<User>>());
    expect((state as BaseData).data.name, 'Test');
  });
}
```

## Widget Testing

```dart
void main() {
  testWidgets('UserListItem displays user data', (tester) async {
    final user = User(id: '1', name: 'Test User', email: 'test@example.com');
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserListItem(user: user, onTap: () {}),
        ),
      ),
    );
    
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
  });
  
  testWidgets('UserListItem calls onTap', (tester) async {
    bool tapped = false;
    final user = User(id: '1', name: 'Test');
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserListItem(
            user: user,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    
    await tester.tap(find.byType(UserListItem));
    expect(tapped, true);
  });
}
```

## Integration Testing

```dart
void main() {
  testWidgets('login flow works end-to-end', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Should show login page
    expect(find.text('Login'), findsOneWidget);
    
    // Enter credentials
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password123');
    
    // Tap login button
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    
    // Should navigate to home
    expect(find.text('Home'), findsOneWidget);
  });
}
```

## Golden Tests

```dart
testWidgets('UserCard matches golden', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: UserCard(user: testUser),
      ),
    ),
  );
  
  await expectLater(
    find.byType(UserCard),
    matchesGoldenFile('goldens/user_card.png'),
  );
});
```

## Coverage

```bash
# Generate coverage
flutter test --coverage

# View coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Target:** 80% minimum, 90% ideal

## Best Practices

### ✅ Do
- Test business logic
- Mock dependencies
- Test error cases
- Use descriptive test names
- Keep tests fast (<100ms each)

### ❌ Don't
- Don't test framework code
- Don't skip edge cases
- Don't write flaky tests
- Don't test implementation details

---

**Your code is now well-tested and reliable!**

