# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

JHenTai is a Flutter app for browsing E-Hentai/EXHentai galleries. It supports Android, iOS, Windows, macOS, and Linux. The entry point is `lib/src/main.dart`.

## Build & Development Commands

```bash
# Run the app (debug)
flutter run -t lib/src/main.dart

# Analyze / lint
flutter analyze

# Build release (platform-specific)
flutter build apk -t lib/src/main.dart --release --split-per-abi    # Android
flutter build ios -t lib/src/main.dart --release --no-codesign       # iOS
flutter build windows -t lib/src/main.dart --release                 # Windows
flutter build linux --release -t lib/src/main.dart                   # Linux

# Generate Drift database code (after schema changes)
dart run build_runner build

# Generate app icons
dart run flutter_launcher_icons
```

Shell scripts for release builds: `apk.sh`, `ipa.sh`, `windows.sh`, `linux.sh`, `dmg.sh`.

There is no test suite in this project.

## Architecture

**State management:** GetX (`get: ^4.7.3`) for state, routing, and dependency injection.

**Page pattern:** Each page follows `View (Page widget) → Logic (GetxController) → State`. Base classes are `BasePage`, `BasePageLogic`, `BasePageState`.

**Routing:** Declarative GetX routes defined in `lib/src/routes/routes.dart`. Supports deep linking.

**Responsive layouts:** Three layout modes — mobile (`layout/mobile_v2/`), tablet, and desktop (`layout/desktop/`). Each has its own home page shell that shares the same page widgets.

**Network layer:**
- `lib/src/network/eh_request.dart` — E-Hentai API client (HTML scraping with the `html` package)
- `lib/src/network/jh_request.dart` — JHenTai backend API client
- Uses a forked `dio` for HTTP with custom cookie/proxy management

**Database:** Drift (SQLite ORM). Tables and DAOs in `lib/src/database/`. After modifying tables, run `dart run build_runner build` to regenerate `database.g.dart`.

**Services:** `lib/src/service/` — singleton business logic services registered with GetX. Key services include:
- `gallery_download_service.dart` / `archive_download_service.dart` — download management
- `tag_translation_service.dart` — tag translation with local DB
- `history_service.dart` / `read_progress_service.dart` — browsing history and read tracking
- `cloud_service.dart` — settings sync

**Settings:** `lib/src/setting/` — reactive preference objects using GetX observables.

**Localization:** 7 languages via GetX translations in `lib/src/l18n/`.

## Code Organization (`lib/src/`)

| Directory | Purpose |
|-----------|---------|
| `config/` | App-wide configuration constants |
| `consts/` | E-Hentai specific constants (URLs, patterns) |
| `database/` | Drift tables, DAOs, generated code |
| `enum/` | Shared enums |
| `exception/` | Custom exceptions |
| `extension/` | Dart/Flutter extension methods |
| `l18n/` | Localization strings |
| `mixin/` | Reusable GetxController mixins |
| `model/` | Data models |
| `network/` | API clients (eh_request, jh_request) |
| `pages/` | All UI pages (82 page directories) |
| `routes/` | Route definitions |
| `service/` | Business logic services |
| `setting/` | User preference objects |
| `utils/` | Utility functions (HTML parsing, file ops, etc.) |
| `widget/` | Shared/reusable widgets |

## Key Conventions

- Lint rules: `always_put_control_body_on_new_line`, `unnecessary_lambdas` (configured in `analysis_options.yaml`)
- Many dependencies are forked (from `jiangtian616` GitHub) with custom patches — check `pubspec.yaml` git refs
- The CI pipeline (`.github/workflows/build_publish.yml`) uses Flutter 3.24.4
