# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter plugin package (`riverpod_app`) providing a pre-configured app widget integrating Riverpod state management, async initialization, and dual-mode navigation (classic imperative + Router API). Uses FVM (pinned to Flutter 3.32.2).

## Common Commands

```bash
# Use FVM-pinned Flutter
fvm flutter analyze
fvm flutter test
fvm flutter test example/test/widget_test.dart   # single test
dart format lib/ example/

# Run the example app
cd example && fvm flutter run
```

## Architecture

**Plugin library** (`lib/src/`):
- `riverpod_app.dart` — Core `RiverpodApp` stateful widget with two constructors: `RiverpodApp.classic()` (imperative Navigator) and `RiverpodApp.declarative()` (Router API). Manages async initialization lifecycle via multiple `Completer`s.
- `navigation/state_navigation_observer.dart` — `RouteObserver` subclass that tracks current route via RxDart `BehaviorSubject`.
- `navigation/blank_page.dart` — Fallback splash placeholder.

**Example app** (`example/lib/`):
- `main.dart` — Demonstrates `RiverpodApp.classic` with async init and splash screen.
- `provider.dart` — Sample `FutureProvider` for initialization state.
- `presentation/generate_route.dart` — Route factory pattern for named routes.

**Key dependencies:** `flutter_riverpod: ^3.0.3`, `rxdart: ^0.28.0`, `plugin_platform_interface: ^2.0.2`.

**Initialization flow:** `RiverpodApp` → runs `init` callback → waits for navigator → calls `beforeSetInitialRoute` → pushes async `initialRoute` → hides splash. Each phase gated by a `Completer`.

## Git Conventions

Do not add `Co-Authored-By` lines to commit messages.

## Lint Rules

Uses `package:flutter_lints/flutter.yaml` with minimal overrides.
