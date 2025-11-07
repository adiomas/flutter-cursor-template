# GlowAI - Smart Photo Editor

AI-powered photo editing app built with Flutter and Supabase.

## ✨ Features Implemented

- ✅ **Authentication System**
  - Email/Password Sign In
  - User Registration
  - Secure token management with Supabase Auth
  - Auth state management with Riverpod

- ✅ **Navigation System**
  - go_router with auth guards
  - Protected routes
  - Declarative navigation
  - Deep linking ready

- ✅ **Dashboard**
  - Welcome screen with user info
  - Quick stats cards
  - Action buttons (ready for features)
  - Profile menu with sign out

## 🏗️ Architecture

**Clean Architecture** with feature-first structure:

```
lib/
├── common/              # Shared across features
│   ├── constants/       # App-wide constants
│   ├── data/           # Supabase service
│   ├── domain/         # Base state, environment, router
│   └── presentation/   # Reusable widgets, spacing
│
├── features/           # Feature modules
│   ├── auth/           # Authentication
│   │   ├── data/       # Models, repositories
│   │   ├── domain/     # Entities, notifiers
│   │   └── presentation/ # Login, Register pages
│   │
│   └── dashboard/      # Dashboard
│       ├── domain/     # Notifiers
│       └── presentation/ # Dashboard page
│
├── theme/             # Design system
│   ├── app_colors.dart
│   └── app_text_styles.dart
│
└── main.dart          # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.16.0+
- Dart 3.0+
- Supabase account

### Setup

1. **Clone and install dependencies:**

```bash
flutter pub get
```

2. **Configure Supabase:**

Edit `lib/common/domain/app_environment.dart`:

```dart
static String get supabaseUrl {
  return 'https://your-project.supabase.co';
}

static String get supabaseAnonKey {
  return 'your-anon-key-here';
}
```

3. **Run the app:**

```bash
flutter run
```

## 📦 Dependencies

**State Management:**
- `hooks_riverpod` - State management
- `flutter_hooks` - React-like hooks

**Navigation:**
- `go_router` - Declarative routing

**Backend:**
- `supabase_flutter` - Supabase client

**Utilities:**
- `either_dart` - Functional error handling
- `equatable` - Value equality
- `q_architecture` - Base architecture utilities

## 🎨 Design System

The app uses a consistent design system:

**Colors:**
- Primary: Indigo (#6366F1)
- Secondary: Purple (#8B5CF6)
- Background: Off-white (#FAFAFA)

**Typography:**
- Display styles for headlines
- Title styles for sections
- Body styles for content

**Spacing:**
- Predefined spacing constants (4, 8, 12, 16, 24, 32, 48px)
- Consistent padding

## 🔐 Authentication Flow

1. User opens app → redirected to Login page
2. User signs in with email/password
3. Auth state managed by Supabase + Riverpod
4. Protected routes only accessible when authenticated
5. Dashboard as main authenticated screen

## 🛠️ Development

### State Management Pattern

Uses `StateNotifier` with custom `BaseState`:

```dart
sealed class BaseState<T> {
  BaseInitial | BaseLoading | BaseData(T data) | BaseError(Failure)
}
```

Example:

```dart
final authState = ref.watch(authNotifierProvider);

authState.when(
  initial: () => LoadingWidget(),
  loading: () => LoadingWidget(),
  data: (user) => DashboardPage(),
  error: (failure) => ErrorWidget(failure),
);
```

### Adding New Features

1. Create feature folder: `lib/features/feature_name/`
2. Add data layer (models, repositories)
3. Add domain layer (entities, notifiers)
4. Add presentation layer (pages, widgets)
5. Register routes in `app_router.dart`

## 📱 Next Steps

Ready to implement:
- [ ] Photo upload & management
- [ ] AI-powered editing
- [ ] Image filters
- [ ] Project management
- [ ] Cloud storage integration
- [ ] Social sharing

## 📝 Notes

- Supabase credentials are placeholders - replace with your actual values
- Environment configuration supports dev/staging/prod
- Auth tokens automatically managed by Supabase
- All user-facing text in English

## 🤝 Contributing

This is a template project following elite Flutter development standards:
- Clean Architecture
- Feature-first structure
- Type-safe navigation
- Reactive state management
- Comprehensive error handling

---

**Built with ❤️ using Flutter & Supabase**
