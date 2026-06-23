# agents.md

> Guidelines for AI coding agents and human contributors working on **Amana Send** — a Flutter cross-platform money transfer app (mobile + web).

---

## 1. Project Overview

**Amana Send** is a Flutter application for sending money internationally. It targets mobile (Android/iOS) and web, built with a custom GraphQL backend.

- **App name:** `amana_send`
- **Package:** `com.amana_send`
- **SDK:** Dart `>=3.3.1 <4.0.0`
- **State management:** `provider` (`ChangeNotifier` / `MultiProvider`)
- **Routing:** `go_router`
- **Networking:** `graphql` (primary) + `http`
- **Backend:** GraphQL endpoint + REST photo upload
- **Auth flow:** Bearer token appended via `AuthLink`

---

## 2. Entry Points & Flavors

The app has **two flavor entry points** that select environment via `F.appFlavor`:

| Entry point             | Flavor          | Base URL              | GraphQL                        |
| ----------------------- | --------------- | --------------------- | ------------------------------ |
| `lib/main_production.dart` | `production`    | `https://amanasend.com/` | `https://api.amanasend.com/graphql` |
| `lib/main_staging.dart`    | `staging`       | `https://amanasend.com/` | `https://s.amanasend.com/graphql`    |

- Flavor selection happens in `lib/flavor.dart` (`enum Flavor { production, staging }`).
- URLs are derived from flavor in `lib/app_config.dart` and exposed through `lib/configs/configs.dart`.
- The shared app bootstrap is `lib/app.dart` → calls `initlize()` then `runApp(const AmanaSend())`.

> Always check `Configs.graphql` / `Configs.apiUrl` instead of hardcoded URLs. Do not edit `AppConfig` directly per-environment — keep flavor mapping centralized.

---

## 3. Directory Structure

```
lib/
├── main_production.dart      # entry: production flavor
├── main_staging.dart         # entry: staging flavor
├── app.dart                  # bootstrap (initlize, runApp)
├── app_config.dart           # flavor → URL mapping
├── flavor.dart               # Flavor enum + F.appFlavor
├── firebase_options.dart     # generated Firebase config
│
├── app/                      # UI layer
│   ├── app.dart              # AmanaSend root widget (MultiProvider, MaterialApp.router)
│   ├── errors/               # error screens, error widget fallback
│   ├── extensions/           # BuildContext extensions (dark_mode, etc.)
│   ├── messages/             # message constants used by app
│   ├── theme/                # colors, gradients, decoration, themes (light/dark)
│   ├── tools/                # language picker, theme picker
│   ├── views/                # screens organized by feature
│   │   ├── camera/
│   │   ├── notifications/
│   │   ├── registration/     # log_in, account_activation, forgot_password, reset_password
│   │   ├── update_app.dart
│   │   ├── web/              # in-app web view
│   │   └── main_pages/       # bottom-nav tabs
│   │       ├── home/         # send hub, payment, success, wallet_address, recipient picker
│   │       ├── recipients/   # list, add, recipient details
│   │       ├── transfers/    # transfer list, transfer details
│   │       ├── account/      # edit, verify, support
│   │       ├── settings/
│   │       ├── provider/     # calculator state
│   │       └── structure.dart  # the bottom-nav shell
│   └── widgets/              # reusable UI (buttons, dialogs, text fields, etc.)
│
├── configs/configs.dart      # app-wide constants: URLs, package name, store URLs
├── database/injector.dart    # SharedPreferences wrapper (Database.inject)
├── extensions/               # dart-level extensions (e.g. context_extension)
├── firebase/firebase.dart    # FCM token + topics
├── global/variables.dart     # Global keys, AppSettings singleton, PageController
├── graphql/                  # GraphQL client + queries/mutations
│   ├── graphql.dart          # GraphQLClient factory with AuthLink
│   ├── api/                  # one file per endpoint (log_in, register, send_transfer, …)
│   └── explorer/
├── helper/                   # log/debug, screen size, safety model
├── https/api/                # REST endpoints (photo upload etc.)
├── localization/             # ARB localization (en + ar)
├── models/                   # plain Dart models (UserModel, Recipient, Transfer, …)
├── router/
│   ├── app_route.dart        # GoRouter definition + route name constants
│   └── guard/auth_guard.dart # auth redirect logic
├── services/                 # singletons (user, lang, theme, notification, popup, chrome, tutorial)
└── settings/
    ├── app_settings.dart     # ChangeNotifier exposed as Global.appSettings
    └── ancestor.dart
```

---

## 4. Core Architecture

### 4.1 Bootstrap (`lib/app.dart` → `initlize()`)

```dart
SystemChromeService.inject();
await Database.inject();         // SharedPreferences
GetMetadata.request();           // app metadata (forces update screen when needed)
await NotificationService.init();
await Global.appSettings.loadSettings();
FirebaseTool.getFirebaseToken().whenComplete(() => FirebaseTool.setFirebaseTopics());
runApp(const AmanaSend());
```

### 4.2 Root widget (`lib/app/app.dart`)

- `AmanaSend` is a `StatelessWidget` wrapping `MaterialApp.router`.
- State providers (`RegistrationState`, `Calculator`, `TransfersState`, `RecipientsState`, `NotificationsState`) are mounted via `MultiProvider`.
- `Global.appSettings` (theme/locale/token) is listened to via `AnimatedBuilder`, so theme/locale changes rebuild the whole tree.
- A `_ResponsiveShell` constrains width to `600px` on large screens (mobile-first layout).
- `FirstGesturePermissionPrompt` wraps every screen for gesture permission overlays.

### 4.3 Routing

- All routes live in `lib/router/app_route.dart` using `go_router`.
- Route names live as **`static const String`** on `AppRoute` and are referenced as `AppRoute.home` etc.
- `Global.appSettings` is the `refreshListenable`, so logging in/out redirects automatically via `guard/auth_guard.dart`.
- The bottom-nav shell is `Structure` (mounted at `AppRoute.home` path `/`).
- The home tab exposes nested routes for camera, web view, send hub, etc.

### 4.4 GraphQL

- Client factory in `lib/graphql/graphql.dart`:
  - `AuthLink(getToken: () async => 'Bearer $token')`
  - `HttpLink(Configs.graphql, defaultHeaders: {'Accept-Language': '${LangService.locale}'})`
- Each API call is its own file under `lib/graphql/api/<operation>.dart` — **follow this pattern** when adding new endpoints.
- REST endpoints (e.g. photo upload) live in `lib/https/api/`.

### 4.5 Settings & Persistence

- `Global.appSettings` (`ChangeNotifier`) is the single source of truth for theme, locale, and auth token.
- Persistence is via `Database` (`SharedPreferences`) injected before `runApp`.
- The token is restored from `UserService.saveUser()` during `loadSettings()`.

---

## 5. Localization

- ARB files live in `lib/localization/`.
  - `app_en.arb` — base (template)
  - `app_ar.arb` — Arabic
  - Generated: `app_localizations.dart`, `app_localizations_en.dart`, `app_localizations_ar.dart`
- Configured in `l10n.yaml`:
  ```yaml
  arb-dir: lib/localization
  template-arb-file: app_en.arb
  output-localization-file: app_localizations.dart
  ```
- App title is set via `onGenerateTitle` from `AppLocalizations.of(context)!.appTitle`.
- Supported locales are exposed from `lib/localization/l10n.dart` (`L10n.all.keys`).
- **Always add both `en` and `ar` translations when introducing strings.**

---

## 6. Theming

- Light + dark themes are defined in `lib/app/theme/themes.dart` (`Themes.light()`, `Themes.dark()`).
- Theme mode is persisted via `ThemeService` and toggled through `Global.appSettings.setThemeMode(...)`.
- Colors / gradients / decoration live under `lib/app/theme/{colors,gradient,decoration,style}/`.
- Theme picker UI lives in `lib/app/tools/theme_picker.dart`.

---

## 7. Conventions & Rules for Agents

### 7.1 Code style

- Lints: `package:flutter_lints/flutter.yaml` (see `analysis_options.yaml`). Run `flutter analyze` before committing.
- **Do not** introduce new lint suppressions; fix the underlying issue.
- The codebase uses absolute package imports — prefer `import '/path/to/file.dart';` over relative imports inside `lib/`.
- Use `Helper.log(...)` for debug logging (supports ANSI colors via `DebugColor`), not raw `print()`.

### 7.2 State management

- Use `provider`'s `ChangeNotifier`. Mount new top-level features in the `MultiProvider` list inside `AmanaSend.build()`.
- Feature state classes live next to their feature:
  - `lib/app/views/main_pages/recipients/provider/recipients_state.dart`
  - `lib/app/views/main_pages/transfers/provider/transfers_state.dart`
  - etc.
- **Do not** introduce `riverpod`, `bloc`, or `GetX` — keep `provider`.

### 7.3 Models

- Plain Dart classes in `lib/models/`. Each domain has its own file (`user.dart`, `recipient.dart`, `transfer.dart`, `country.dart`, `currency.dart`, …).
- Models serialize via `toJson()` / `fromJson(...)` factories.

### 7.4 Routing

- Add new routes inside `AppRoute.routes` in `lib/router/app_route.dart`.
- Define the route name as `static const String` and reference it through `AppRoute.<name>`.
- Use `Guard.authGuard` (from `router/guard/auth_guard.dart`) to protect screens.

### 7.5 Networking

- New GraphQL operation → new file under `lib/graphql/api/<verb>_<entity>.dart`.
- Always read the URL from `Configs.graphql` — never hardcode.
- Always include `'Accept-Language': '${LangService.locale}'` for backend localization consistency.
- REST calls live under `lib/https/api/`.

### 7.6 UI

- Mobile-first. The `600px` responsive shell is enforced in `_ResponsiveShell`.
- Reuse widgets from `lib/app/widgets/` whenever possible (buttons, dialogs, text fields).
- Reusable `Structure` (bottom nav) is at `lib/app/views/main_pages/structure.dart`.
- Lottie/JSON animations are pre-loaded in `assets/json/` and referenced through `Lottie.asset(...)`.

### 7.7 Firebase / Notifications

- Config is generated in `lib/firebase_options.dart`.
- FCM tokens handled by `FirebaseTool` (`lib/firebase/firebase.dart`).
- Local notifications handled by `NotificationService` (`lib/services/notification_service.dart`).

### 7.8 Platforms

- Android configuration: `android/app/build.gradle`, `key.properties`, `local.properties`.
- iOS configuration: `ios/Runner/Info.plist`, `Runner.entitlements`, `Podfile`.
- Web configuration: `web/index.html`, `web/firebase-messaging-sw.js`, `web/manifest.json`.
- Firebase platform JSONs are present for both Android (`android/app/google-services.json`) and iOS (`ios/Runner/GoogleService-Info.plist`).

---

## 8. Build & Run

```bash
# Install dependencies
flutter pub get

# Static analysis
flutter analyze

# Run a specific flavor
flutter run --target lib/main_staging.dart -d <device>
flutter run --target lib/main_production.dart -d <device>

# Build (mobile)
flutter build apk                # production flavor requires --target
flutter build ios                # production flavor requires --target

# Localization regen
flutter gen-l10n
```

> Both flavors share the same root `AmanaSend` widget; flavor toggles `F.appFlavor` **before** `initlize()`.

---

## 9. Asset Map

| Kind     | Path                    | Notes                                        |
| -------- | ----------------------- | -------------------------------------------- |
| Images   | `assets/images/`        | PNG/JPG for app screens                      |
| JSON     | `assets/json/`          | Lottie files (success, error, geo, arrows)   |
| SVG      | `assets/svg/`           | Vector icons used with `flutter_svg`         |
| Icons    | `assets/icons/`         | Custom app icons                             |
| Fonts    | `assets/fonts/`         | `work_sans`, `almarai`, `halter`             |

---

## 10. Quick Reference — Common Tasks

| Task                                | Where to start                                                                 |
| ----------------------------------- | ------------------------------------------------------------------------------ |
| Add a new GraphQL call              | Create `lib/graphql/api/<operation>.dart` using `GraphQL.client()` from `lib/graphql/graphql.dart`. |
| Add a new screen                    | 1. Create widget in `lib/app/views/<feature>/` → 2. Register route in `lib/router/app_route.dart` → 3. Add `static const` route name on `AppRoute`. |
| Add new translation                 | Append key to `lib/localization/app_en.arb` **and** `lib/localization/app_ar.arb`, then `flutter gen-l10n`. |
| Add a new tab to bottom nav         | Extend `Structure` in `lib/app/views/main_pages/structure.dart`.               |
| Change environment URL              | Edit `lib/app_config.dart` (per-flavor).                                       |
| Toggle dark/light mode globally     | Update `lib/app/theme/themes.dart`.                                            |
| Add a new persistent setting        | Extend `lib/settings/app_settings.dart` + use existing `ThemeService` / `LangService` or add a new service in `lib/services/`. |

---

## 11. What Agents Should NOT Do

- ❌ Don't hardcode URLs, package names, or flavor-specific values.
- ❌ Don't introduce alternative state-management libraries.
- ❌ Don't skip `ar` translations — Arabic is a first-class locale.
- ❌ Don't add unannotated `print()`s — use `Helper.log(...)`.
- ❌ Don't bypass `Global.appSettings`/`Database` for app-wide state or persistence.
- ❌ Don't commit to a flavor branch path that bypasses `F.appFlavor`.
- ❌ Don't modify generated files in `lib/localization/app_localizations*.dart` manually — regenerate via `flutter gen-l10n`.