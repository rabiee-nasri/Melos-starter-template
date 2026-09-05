import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

// Hand-written providers, no code generation. get_it wires the
// infrastructure once; Riverpod makes the state observable to widgets.
final inventoryRepositoryProvider = Provider<InventoryRepository>(
  (ref) => InventoryRepository(getIt<ApiClient>(), getIt<LocalCache>()),
);

final inventoryProvider = StreamProvider<Inventory>(
  (ref) => ref.watch(inventoryRepositoryProvider).watchInventory(),
);

final navigatorProvider = Provider<AppNavigator>(
  (ref) => getIt<AppNavigator>(),
);
