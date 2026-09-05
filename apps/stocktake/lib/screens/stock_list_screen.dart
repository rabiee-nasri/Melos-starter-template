import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/inventory_state.dart';

class StockListScreen extends ConsumerWidget {
  const StockListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(inventoryProvider);
    final navigator = ref.watch(navigatorProvider);

    return Scaffold(
      appBar: const SiteAppBar(title: 'Stocktake'),
      body: switch (inventory) {
        AsyncData(:final value) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: value.items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final item = value.items[i];
            return StockCard(
              title: item.name,
              subtitle: '${item.bin}  ${_quantity(item)}',
              icon: Icons.fact_check_outlined,
              onTap: () => navigator.openItem(item.sku),
            );
          },
        ),
        AsyncError(:final error) => Center(child: Text('$error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  String _quantity(StockItem item) => switch (item) {
    PalletItem(:final cases) => '$cases cases',
    CartonItem(:final units) => '$units units',
    LooseItem(:final quantity) => '$quantity pcs',
  };
}
