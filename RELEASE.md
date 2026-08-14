# Doctory — Release & Publish Guide (Android + iOS)

> Step-by-step checklist to take Doctory from development to **Google Play** and **App Store**.
> Follow it in order. Every value below was verified against the actual project (2026-08-05).
> Where something is missing (e.g., "your own password"), the placeholder is `___`.

---

## 1. Project Identity Cheat-Sheet

| Item | Value | Where it lives |
|---|---|---|
| App display name | `Doctory` | iOS Info.plist `CFBundleDisplayName`, Android `strings.xml` `app_name` |
| Android applicationId | `com.clinichub.doctory` | `android/app/build.gradle.kts` (`namespace` + `applicationId`) |
| iOS bundle identifier | `com.clinichub.doctory` | `ios/Runner.xcodeproj/project.pbxproj` |
| Version | `1.0.0+1` | `pubspec.yaml` (`version: 1.0.0+1`) |
| Firebase project | `doctory-1aca1` | `google-services.json` + `firebase_options.dart` |
| Firebase sender ID | `1077893614286` | same |
| Min SDK / iOS target | Android: Flutter default · iOS 15.0 | `build.gradle.kts`, `Podfile`, pbxproj |
| Deep links (domain) | `https://clinicHub.app/...` | AndroidManifest intent-filter, iOS entitlements |

### 1.1 Android debug key fingerprints (dev builds only)

Generated from the **default debug keystore** — used today because release currently signs with debug key:

```
Keystore : %USERPROFILE%\.android\debug.keystore
Alias    : androiddebugkey
Pass     : android

SHA-1   : F9:54:0E:EF:24:A6:65:C1:E2:15:FE:60:50:BB:13:F4:23:B0:42:6C
SHA-256 : 7B:07:9F:DB:71:5D:8C:29:59:50:F5:06:B2:A9:CF:C8:AA:51:D2:34:A0:02:30:B1:14:58:8E:29:CA:74:69:4B
```

> ⚠️ **Before release you MUST create a real upload keystore (step 3.2).** The debug SHA-1 above is
> already authorized for Google Maps (`...;com.clinichub.doctory`), so dev builds keep working.

---

## 2. Secrets & Config Files (never commit)

| File | Gitignored? | Contents |
|---|---|---|
| `android/local.properties` | ✅ `android/.gitignore` | `mapsApiKey=AIzaSyD0zRl4KKc394VUOG46r1QGTwVLH8Tu_do` |
| `android/key.properties` | ✅ `android/.gitignore` | upload keystore credentials (create in step 3.2) |
| `android/app/release-keystore.jks` | ✅ `**/*.jks` | your private keystore (create in step 3.2) |

- Google Maps **Android** API key (above) → injected at build time via gradle placeholder `${mapsApiKey}`.
- Google Maps **iOS** API key → hardcoded in `ios/Runner/Info.plist` under `GMSApiKey` (same key today).
  > Recommended: before App Store submission, give iOS its own key restricted to the iOS bundle ID (step 5.4).

---

## 3. ANDROID — Google Play Release

### 3.1 Prerequisites
- Google Play developer account ($25 one-time, https://play.google.com/console).
- Project builds: `flutter build apk --release` (already verified ✅).

### 3.2 Create your upload keystore (ONE TIME)

Run in `android/`:

```
keytool -genkeypair -v -keystore release-keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000
```

Answer prompts (organization details appear in Play's "signed by" info; anything works).
**Store passwords in a password manager — losing them loses the app's ability to be updated.**
Check `release-keystore.jks` SHA-1 for your records:

```
keytool -list -v -keystore release-keystore.jks -storepass ___
```

### 3.3 Wire signing into the build

Create `android/key.properties`:

```
storePassword=doctory_release_2026
keyPassword=doctory_release_2026
keyAlias=doctory_alias
storeFile=release-keystore.jks
```

Edit `android/app/build.gradle.kts`:
- Read `key.properties` (Kotlin DSL — FileInputStream pattern like the existing `mapsApiKey` block).
- Add `signingConfigs { create("release") { ... from key.properties ... } }`.
- Replace `release { signingConfig = signingConfigs.getByName("debug") }` (line 65) with the release config.

### 3.4 Google Play Console — create the app

1. Console → **Create app** → name `Doctory`, default language, free/paid.
2. **Set up your app**:
   - App access: choose.
   - **App signing**: choose "Let Google manage and protect your app signing key" (Play App Signing — required for Play; your `release-keystore.jks` becomes the *upload key*).
   - You'll get an **App Signing SHA-1 / SHA-256 certificate fingerprint** — copy them (needed for Google Maps + Firebase in production, step 5.4).
3. **Store listing**: app icon (auto-generated via `flutter_launcher_icons`), feature graphic (1024×500 PNG), phone/tablet screenshots, category, short/full description, contact email, **privacy policy URL (required)**.
4. **App content**: data safety form (do this — the app collects location, camera, mic, photos, personal info), content rating questionnaire, target audience (children? ads?).
5. **Main store listing + Production track**: upload the AAB (step 3.6), set release notes, roll out.

### 3.5 Bump the version before releasing

Edit `pubspec.yaml`:

```yaml
version: 1.1.0+2   # versionName + versionCode
```

- `versionCode` must be **strictly higher** than any previously uploaded build.
- First release: `1.0.0+1` is fine.

### 3.6 Build the release artifact

```
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab` → upload to Play Console (Production track).

### 3.7 Test the release before publishing

```
flutter build apk --release
adb install build/app/outputs/flutter-apk/app-release.apk
```

Smoke test (step 7).

---

## 4. iOS — App Store Release (needs a Mac with Xcode)

### 4.1 Prerequisites
- Apple Developer Program ($99/yr) — https://developer.apple.com/account.
- Xcode 15+ on a Mac. Archive happens **on the Mac**; all project changes below happen in this repo.

### 4.2 Apple Developer Portal — identities

1. **Register the Bundle ID** `com.clinichub.doctory` (Identifiers → App IDs) with capabilities:
   - Push Notifications
   - Associated Domains (already configured in project)
   - Sign in with Apple / Google Sign-In: **none** (Flutter handles them; no native capability needed)
2. **Create an APNs Auth Key** (Keys → All) — save the `.p8` file; needed for Firebase FCM (step 6.4).
   > ⚠️ Only **one** APNs key per team — reuse it across apps.

### 4.3 Fix iOS bundle ID in Firebase FIRST (blocker)

Firebase's iOS app is currently registered as `com.clinichub.doctory` but the app builds as `com.clinichub.doctory` — **must be fixed before anything Firebase works on iOS**.

1. Firebase Console → Project `doctory-1aca1` → Project settings → iOS apps → **Add app** with bundle ID `com.clinichub.doctory`.
2. Add Google Sign-In: Credentials → Create OAuth client ID → iOS → bundle `com.clinichub.doctory`.
3. Regenerate config for this repo (run on a machine with Flutter + Dart):

```
dart pub global activate flutterfire_cli
flutterfire configure --project=doctory-1aca1 --platforms=ios,android
```

This rewrites `lib/firebase_options.dart` with the correct `iosBundleId: 'com.clinichub.doctory'`.

### 4.4 Xcode — signing & capabilities (on the Mac)

1. `open ios/Runner.xcworkspace` (Xcode).
2. Runner target → **Signing & Capabilities**:
   - Select your **Team** (this fills `DEVELOPMENT_TEAM` in pbxproj).
   - Bundle ID: `com.clinichub.doctory` (already set).
   - Add capabilities: **Push Notifications**, **Background Modes → remote notifications + location** (entitlements already in `ios/Runner/Runner.entitlements`).
3. Update `aps-environment` in `Runner.entitlements` to `production` for the distribution build (Xcode sets this automatically when archiving with distribution profile; verify before Archive).
4. Google Sign-In iOS:
   - Add the **REVERSED_CLIENT_ID** from Firebase → iOS app → Google Sign-In as `CFBundleURLTypes` entry in `ios/Runner/Info.plist`.
   - Add `GIDClientID` key (same client ID, non-reversed) to `Info.plist`.
   - (This is also needed by `google_sign_in` — do it before testing login on iOS.)
5. Facebook iOS login (if used): add `FacebookAppID`, `FacebookClientToken`, `FacebookDisplayName` + URL scheme `fb716787291496736` to `Info.plist`.

### 4.5 Add iOS Google Maps key restriction (step 5.4) — map breaks otherwise

### 4.6 Build & submit

```
flutter build ipa --release
```

Output: `build/ios/ipa/*.ipa` → upload via **Transporter** or Xcode Organizer → **App Store Connect**:

1. App → New version `1.0.0(1)` → screenshots (iPhone 6.7"/6.5"), description, **privacy policy URL**, export compliance (encryption: usually "exempt" if HTTPS-only).
2. **TestFlight** first → install on a real iPhone → run smoke test (step 7).
3. Submit for Review.

---

## 5. Google Cloud — Maps API Keys (Android + iOS)

### 5.1 Console: https://console.cloud.google.com → project with your billing enabled
> Maps SDK needs a **billing account attached** (free tier: $200/month credit; without billing the SDK refuses to render).

### 5.2 Enable APIs (Android)
- **Maps SDK for Android** — enabled.
- Also enabled in project: Firebase, Crashlytics, Analytics (managed via Firebase).

### 5.3 Android key restriction (ALREADY DONE ✅)
Key `AIzaSyD0zRl4KKc394VUOG46r1QGTwVLH8Tu_do` → Android apps restriction contains:

```
F9:54:0E:EF:24:A6:65:C1:E2:15:FE:60:50:BB:13:F4:23:B0:42:6C;com.clinichub.doctory   (debug key)
```

**After Play App Signing (step 3.4)**: add the **App Signing SHA-1** from Play Console the same way:
`<APP_SIGNING_SHA1>;com.clinichub.doctory` — otherwise the Play-signed release build shows the
"Authorization failure" logcat error and a blank map.

### 5.4 iOS key (recommend a separate key)
1. Create a second API key (or reuse) → **Application restrictions → iOS apps** → add bundle ID `com.clinichub.doctory`.
2. Update `ios/Runner/Info.plist` → `GMSApiKey`.
3. Enable **Maps SDK for iOS** in the same Cloud project.

---

## 6. FIREBASE — Final Checks

| Task | Android | iOS |
|---|---|---|
| App registered | ✅ `com.clinichub.doctory` | ❌ **re-register as `com.clinichub.doctory` (step 4.3)** |
| Config file | ✅ `google-services.json` in repo | config via `flutterfire configure` (no plist needed) |
| Cloud Messaging | ✅ works via json | needs **APNs key** upload (step 6.4) |
| Crashlytics | ✅ gradle applied | ✅ same via Firebase SDK |

### 6.1 Firebase Console → Project settings
- **Your apps** tab: confirm both platform entries match the table above after step 4.3.

### 6.2 Google Sign-In (Android)
- Android client ID `1077893614286-kf613gevsk5pq68739hfr34h5vfjt708.apps.googleusercontent.com` exists in `google-services.json` ✅
- If release build's cert hash (`certificate_hash` in json) was the debug key, **update it** in Firebase console to the Play App Signing SHA-1 (step 3.4) — Google Sign-In breaks on the Play build otherwise.

### 6.3 Facebook login
- Android app id `716787291496736` in `strings.xml` ✅.
- iOS: add Facebook plist entries (step 4.4.5).
- Facebook Developer dashboard: add platform Android (key hash = **SHA-1 of upload/signing key, colon-free lowercase**: `f9540eef24a665c1e215fe6050bb13f423b0426c` for dev; recompute for production key) and iOS bundle.

### 6.4 Push Notifications (FCM)
1. Apple → APNs key (step 4.2.2) → save `.p8` (Key ID + Team ID at hand).
2. Firebase → Project settings → Cloud Messaging → **Apple app configuration** → upload `.p8`.
3. iOS test: send test push from Firebase console to a TestFlight device.
4. Android: `POST_NOTIFICATIONS` runtime permission on 13+ (already declared in manifest).

---

## 7. Pre-Publish Smoke Test (do on real devices)

- [ ] Fresh install → login (email / Google / Facebook — each provider)
- [ ] Home map loads with markers (no `Authorization failure` in logcat, no freeze)
- [ ] Permission dialogs appear correctly (location, camera, mic, photos, notifications)
- [ ] Deep links `clinicHub.app/clinic/...` open the right screen (test with `adb shell am start -a android.intent.action.VIEW -d "https://clinicHub.app/clinic/x"`)
- [ ] Push notification received in foreground + background
- [ ] Upload/download an image (photo permission)
- [ ] `dart analyze` → **0 errors, 0 warnings**
- [ ] Release AAB/IPA installs and runs (not just debug build)

---

## 8. Critical Order of Operations

```
1. Play Console app + App Signing (get production SHA-1)
2. Firebase: iOS app with real bundle ID + google-services alignment
3. Google Cloud: add production SHA-1 to Android Maps key; iOS key + bundle restriction
4. APNs key → Firebase Cloud Messaging
5. Xcode signing (Team) + plist entries (Google/Facebook)
6. Version bump → build AAB / IPA → TestFlight → Play internal testing
7. Smoke test → production rollout / App Review
```

---

## 9. Known Pitfalls (from this project's history)

- **Blank Android map** in logcat `Authorization failure` → Maps key missing the **signing key's** SHA-1 (`<fingerprint>;com.clinichub.doctory`). Debug build = debug SHA-1; Play build = App Signing SHA-1.
- **Marker freeze/crash on map** (Redmi Note 9 Pro/12 Pro) → marker PNG generation was done synchronously on the UI thread; fixed with isolate-based generation in `lib/features/map_home/presentation/widgets/marker_generator.dart`.
- **`google-services.json` and bundle ID must match `applicationId`** — never change the Android package name after the first Play upload.
- **Never change the iOS bundle ID** after Firebase/OAuth clients are created — it invalidates Google Sign-In, Maps, and FCM silently.
- Losing `release-keystore.jks` + its passwords = cannot ship updates through Play.
- **Do not commit**: `android/key.properties`, `*.jks`, `local.properties`, `.p8` files, keystore passwords.
