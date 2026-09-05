import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'navigation/go_router_navigator.dart';
import 'router.dart';

final getIt = GetIt.instance;

/// Composition root. The only place that knows which concrete
/// ApiClient, LocalCache and AppNavigator this app runs on.
void registerDependencies() {
  getIt
    ..registerSingleton<ApiClient>(
      AssetApiClient({'/v1/inventory': 'assets/inventory.json'}),
    )
    ..registerSingleton<LocalCache>(InMemoryCache())
    ..registerSingleton<AppNavigator>(GoRouterNavigator(router));
}

void main() {
  registerDependencies();
  runApp(const ProviderScope(child: StocktakeApp()));
}

class StocktakeApp extends StatelessWidget {
  const StocktakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Stocktake',
      theme: AppTheme.light(Colors.teal),
      routerConfig: router,
    );
  }
}
