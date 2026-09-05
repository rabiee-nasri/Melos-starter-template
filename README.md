# Melos starter template

A small, runnable Flutter monorepo: three thin app shells, one shared data layer, one shared design system, and a build that fails when a package reaches somewhere it should not.

The reasoning behind the structure is written up in [Flutter Monorepo Architecture with Melos](https://rabieenasri.com/posts/flutter-monorepo-architecture). This repository is a generic demonstration of the same rules, written from scratch, in an unrelated domain: three handheld apps for a warehouse floor that share one inventory feed.

Built and verified with Flutter 3.47.2 (stable), Dart 3.13.2 and Melos 8.6.0.

## Layout

```
pubspec.yaml            workspace members, melos as a dev dependency, melos scripts
analysis_options.yaml   included by every package; the dependency lints are errors here
apps/
  receiving/            goods in: entry point, route table, two screens, wiring
  picking/              goods out: same shape, different data and colour
  stocktake/            counting: same shape, different data and colour
packages/
  core/                 ApiClient, LocalCache, InventoryRepository, AppNavigator, item parser
  components/           theme, StockCard, SiteAppBar
.github/workflows/ci.yml
```

Each app lists stock items and opens a detail screen for one. The inventory is data, not code: `apps/<app>/assets/inventory.json` stands in for the backend, and each file contains one packaging type the parser does not know so you can see it being skipped instead of breaking the list.

Two tools with two jobs. Dart pub workspaces give every package one dependency resolution and one `pubspec.lock`. Melos runs commands across the workspace. Every member package carries `resolution: workspace` in its pubspec.

## The three rules the build enforces

1. Apps depend on `core` and `components` only. Never on another app.
2. `core` and `components` never depend on each other, and never on an app.
3. Nobody imports another package's `src/` directory. Packages talk through `core.dart` and `components.dart`.

Rules 1 and 2 are pubspec entries: the dependency is simply not declared. In a workspace that alone is not enough, because every package resolves together and an undeclared import still compiles. `analysis_options.yaml` closes the gap by raising two lints to errors:

```yaml
analyzer:
  errors:
    depend_on_referenced_packages: error
    implementation_imports: error
```

### What you see when you break them

These are the actual analyzer results from this repository, produced by adding one import line, running `melos run analyze`, and reverting.

`packages/components` importing `package:core/core.dart`:

```
error • The imported package 'core' isn't a dependency of the importing package.
        Try adding a dependency for 'core' in the 'pubspec.yaml' file
        • lib/src/stock_card.dart:1:8 • depend_on_referenced_packages
```

`apps/receiving` importing `package:picking/main.dart`:

```
error • The imported package 'picking' isn't a dependency of the importing package.
        Try adding a dependency for 'picking' in the 'pubspec.yaml' file
        • lib/router.dart:1:8 • depend_on_referenced_packages
```

`apps/receiving` importing `package:core/src/data/api_client.dart`:

```
error • Import of a library in the 'lib/src' directory of another package.
        Try importing a public library that exports this library, or removing the import
        • lib/state/inventory_state.dart:1:8 • implementation_imports
```

In each case `melos run analyze` exits with code 1 and CI goes red. Adding the dependency to the pubspec to make the first two pass is a visible change in the same pull request, which is the point.

## Wiring inside an app

- State is Riverpod, written by hand. No `build_runner`, no generated files. See `apps/receiving/lib/state/inventory_state.dart`.
- Dependency injection is `get_it` at the composition root. `apps/receiving/lib/main.dart` registers the concrete `ApiClient`, `LocalCache` and `AppNavigator` once at startup. `core` never learns which platform or app it runs in.
- Navigation is `go_router`. Shared code never calls it directly. It navigates through the `AppNavigator` interface in `core`, and each app maps that interface onto its own route table in `navigation/go_router_navigator.dart`.
- `InventoryRepository.watchInventory()` yields the cached inventory first and the network result second. The unit test in `packages/core/test` checks exactly that order.

For the demo the "API" is a bundled JSON asset (`AssetApiClient`) and the cache is a map (`InMemoryCache`). Both implement the same interfaces a real HTTP client and on-device store would, and the tests inject fakes in their place.

## Running it

Install Flutter, then activate Melos once:

```bash
dart pub global activate melos
```

Bootstrap the workspace from the repository root. This runs one `flutter pub get` for all five packages:

```bash
melos bootstrap
```

Analyze, test and check formatting across every package:

```bash
melos run analyze
melos run test
melos run format
```

Run an app on a connected device or a running simulator:

```bash
cd apps/receiving && flutter run
```

Swap `receiving` for `picking` or `stocktake`. Each app has Android and iOS platform folders, generated by `flutter create`.

## Continuous integration

`.github/workflows/ci.yml` runs `melos bootstrap`, `melos run analyze`, `melos run test` and `melos run format` on every push to `main` and every pull request.

## Licence

MIT. Author: Mohammad Rabiee Nasri.
