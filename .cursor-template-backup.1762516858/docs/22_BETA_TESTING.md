# Beta Testing

Distribute beta builds for testing before production release.

## TestFlight (iOS)

1. Archive app in Xcode
2. Distribute → App Store Connect
3. Wait for processing
4. Add testers in App Store Connect
5. Invite testers via email
6. Monitor feedback

## Firebase App Distribution

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Deploy
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_APP_ID \
  --groups testers \
  --release-notes "New features and bug fixes"
```

## Internal Testing (Play Console)

1. Upload AAB to Play Console
2. Create internal testing track
3. Add testers (email list)
4. Share testing link
5. Monitor feedback

---

**Beta testing is now set up!**

