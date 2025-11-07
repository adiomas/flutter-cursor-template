# GlowAI Scripts

Scripts for running the app in different environments.

## Quick Start

### Using Makefile (Recommended)

```bash
# Development
make run-dev

# Staging
make run-staging

# Production
make run-prod
```

### Using Shell Script

```bash
# Development
./scripts/run.sh dev

# Staging
./scripts/run.sh staging

# Production
./scripts/run.sh prod
```

### Direct Flutter Commands

```bash
# Development
flutter run --dart-define=ENV=dev

# Staging
flutter run --dart-define=ENV=staging

# Production
flutter run --dart-define=ENV=prod --release
```

## Viewing Logs

### In Terminal

All logs are automatically printed to the terminal when running `flutter run`. The logger uses different levels:

- **TRACE** 🔍 - Very detailed debugging (dev only)
- **DEBUG** 🐛 - Debug information (dev/staging)
- **INFO** 💡 - General information
- **WARNING** ⚠️ - Warnings
- **ERROR** ❌ - Errors
- **FATAL** 💀 - Critical errors

### In App (Developer Console)

1. **Shake your device** (dev/staging only)
2. Developer console opens automatically
3. View all logs in real-time
4. Filter by level, search, export logs

### Log Examples

When you run the app, you'll see logs like:

```
🔍 [2024-01-15 10:30:45] 🔐 Starting sign in with email: user@example.com
🐛 [2024-01-15 10:30:45] Calling Supabase signInWithEmailPassword...
🐛 [2024-01-15 10:30:46] Supabase response received
💡 [2024-01-15 10:30:46] ✅ Sign in successful for user: abc123
```

## Troubleshooting Login Issues

If login is failing, check the logs for:

1. **AuthException** - Supabase authentication errors
2. **No session/user returned** - Response validation failed
3. **State type** - Check what state the notifier is in

Look for these log patterns:
- `🔐 Starting sign in` - Login process started
- `✅ Sign in successful` - Login succeeded
- `❌ Sign in failed` - Login failed (check error details)

## Other Commands

```bash
# Run tests
make test

# Static analysis
make analyze

# Format code
make format

# Clean build
make clean
```

