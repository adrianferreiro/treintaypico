# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

EVNTS POS — a Flutter POS (Point of Sale) app for managing event orders in real-time. Optimized for Android tablets. Shares a Firebase backend with the [event-app](https://github.com/adrianferreiro/event-app) React/TypeScript web client.

## Common Commands

```bash
flutter pub get              # Install dependencies
flutter run -d <device-id>   # Run on specific device
flutter run                  # Run on default device
flutter analyze              # Static analysis (uses flutter_lints)
dart format lib/             # Format code
flutter clean && flutter pub get  # Clean rebuild
flutter build apk            # Build Android APK
flutter test                 # Run tests
```

Firebase setup requires FlutterFire CLI: `flutterfire configure --project=<project-id>`. The files `firebase_options.dart` and `google-services.json` are not in the repo.

## Architecture

**Clean Architecture** with four layers per feature:

```
lib/features/<feature>/
  domain/       → Entities, repository interfaces
  data/         → Models, datasources, repository implementations, mappers
  application/  → Controllers (StateNotifier), states (sealed classes), use cases, providers
  presentation/ → Screens (ConsumerStatefulWidget), widgets
```

Shared code lives in `lib/core/` (network, styles, widgets, providers) and `lib/config/` (routes, constants).

### Key Patterns

- **State management**: Riverpod with `StateNotifier<T>` controllers and sealed state classes (e.g., `OrderInitial | OrderLoading | OrderLoaded | OrderSuccess | OrderError`)
- **Error handling**: `dartz` `Either<Failure, T>` return types in repositories. Failure subtypes: `NotFoundFailure`, `AlreadyScannedFailure`, `StorageFailure`, `UnexpectedFailure`
- **Use cases**: Abstract `UseCase<OutputType, InputParams>` base class, each with its own Riverpod provider
- **Mappers**: Extension methods on models for `toEntity()` conversion (e.g., `OrderMapper`)
- **Routing**: `go_router` with role-based redirects in `lib/config/routes/router.dart`
- **Auth**: Firebase Auth (email/password) + Firestore user lookup for role resolution. Roles: `admin`, `cashier`, `bartender`, `client`

### Firestore Collections

- `orders` — Order documents with nested `items` array. Key fields: `order_number`, `status` (pending/paid/cancelled), `isPaid`, `payment_method`, `total_amount`, `isOrderActive`
- `users` — User profiles with `role`, `companyId`, `venueId`, `isActive`

## Current Features

- **Auth**: Login/logout with role-based routing (all roles currently route to `/order`)
- **Orders**: Search by order number → display details → mark as paid or cancel

## Conventions

- Firestore field names use `snake_case`; Dart code uses `camelCase`
- UI text and comments are in Spanish
- Dark theme optimized for POS use (`lib/core/styles/app_colors.dart`, `lib/theme/app_theme.dart`)
- Screens use `ConsumerStatefulWidget` when needing both lifecycle methods and Riverpod
- Datasources have a fake implementation for testing (e.g., `fake_order_datasource.dart`)
