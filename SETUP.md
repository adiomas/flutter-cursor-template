# GlowAI - Setup Guide

Quick setup guide to get GlowAI running.

## ✅ Što je gotovo

- ✅ Complete Authentication System (Login/Register)
- ✅ Navigation with Auth Guards
- ✅ Dashboard with User Info
- ✅ Design System (Colors, Typography, Spacing)
- ✅ Clean Architecture Structure
- ✅ State Management with Riverpod
- ✅ Error Handling

## 🚀 Quick Start

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Setup Supabase

Trebaš Supabase projekt za autentifikaciju.

**Option A: Use Existing Project**
1. Go to https://supabase.com
2. Create or select project
3. Copy Project URL and anon key from Settings → API

**Option B: Skip Supabase (App will work but login won't)**
- App će se buildat i runnat
- Login/Register neće raditi bez Supabase credentials

### 3. Add Supabase Credentials

Edit `lib/common/domain/app_environment.dart`:

```dart
// Replace with your actual values
static String get supabaseUrl {
  return 'https://YOUR-PROJECT.supabase.co';  // ← Your URL here
}

static String get supabaseAnonKey {
  return 'your-anon-key-here';  // ← Your key here
}
```

### 4. Run the App

```bash
flutter run
```

## 📱 Features Ready to Use

### Authentication
- **Login Page**: Email/password login
- **Register Page**: New user registration
- **Auth State**: Automatic login persistence
- **Protected Routes**: Dashboard only accessible when logged in

### Dashboard
- **User Welcome**: Shows user name/email
- **Stats Cards**: Ready for project counts
- **Quick Actions**: Placeholder buttons for features
- **Profile Menu**: Settings & Sign out

### Design System
All UI components use:
- **Consistent Colors**: Primary (Indigo), Secondary (Purple)
- **Typography Styles**: Display, Title, Body, Label
- **Spacing System**: 4, 8, 12, 16, 24, 32, 48px
- **Reusable Widgets**: Loading, Error views

## 🛠️ Development

### Project Structure

```
lib/
├── common/
│   ├── constants/          # App constants
│   ├── data/              # Supabase service
│   ├── domain/            # Base state, router, environment
│   └── presentation/      # Shared widgets
│
├── features/
│   ├── auth/              # Authentication feature
│   │   ├── data/          # Auth repository
│   │   ├── domain/        # User entity, notifiers
│   │   └── presentation/  # Login/Register pages
│   │
│   └── dashboard/         # Dashboard feature
│       └── presentation/  # Dashboard page
│
├── theme/                 # Design system
└── main.dart             # Entry point
```

### Adding New Features

Follow this pattern:

1. **Create Feature Folder**: `lib/features/new_feature/`
2. **Data Layer**: Models, repositories
3. **Domain Layer**: Entities, notifiers (state management)
4. **Presentation Layer**: Pages, widgets
5. **Register Route**: Add to `lib/common/domain/router/app_router.dart`

### State Management

Uses StateNotifier with custom BaseState:

```dart
// In your notifier
state = const BaseLoading();  // Show loading
state = BaseData(data);       // Show data
state = BaseError(failure);   // Show error

// In your widget
final state = ref.watch(yourNotifierProvider);

state.when(
  initial: () => SomeWidget(),
  loading: () => LoadingWidget(),
  data: (data) => DataWidget(data),
  error: (failure) => ErrorWidget(failure),
);
```

## 📝 Next Steps

Ready to implement:

1. **Photo Upload**
   - Add image_picker dependency
   - Create upload page
   - Supabase Storage integration

2. **AI Editing**
   - Add AI service (OpenAI/Stable Diffusion)
   - Image processing
   - Filters & effects

3. **Projects**
   - Project CRUD operations
   - Gallery view
   - Favorites

4. **Settings**
   - Profile editing
   - Theme switching (dark mode)
   - Preferences

## 🔧 Troubleshooting

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

### Supabase Connection
- Check if URL and key are correct
- Ensure internet connection
- Verify Supabase project is active

### State Not Updating
- Check if using `ref.watch` in build
- Verify notifier is calling `state =`
- Look for console errors

## 📚 Key Files

- `lib/main.dart` - App entry, theme config
- `lib/common/domain/router/app_router.dart` - All routes & auth guards
- `lib/features/auth/domain/notifiers/auth_notifier.dart` - Auth state management
- `lib/common/domain/app_environment.dart` - Environment & Supabase config
- `lib/theme/app_colors.dart` - Color palette
- `lib/theme/app_text_styles.dart` - Typography

## 🎨 Customization

### Change Colors
Edit `lib/theme/app_colors.dart`:
```dart
static const primary = Color(0xFF6366F1);  // Your color here
```

### Change App Name
Edit `lib/common/domain/app_environment.dart`:
```dart
static String get appTitle => 'Your App Name';
```

### Add New Route
Edit `lib/common/domain/router/app_router.dart`:
```dart
GoRoute(
  path: '/your-route',
  builder: (context, state) => const YourPage(),
),
```

---

**All set!** 🚀 App je spreman za development. Implementiraj nove feature prema template-ima iz `docs/` foldera.

