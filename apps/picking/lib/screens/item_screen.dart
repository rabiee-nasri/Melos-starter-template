import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/inventory_state.dart';

/// Detail screen. Looks the item up in the inventory already in memory.
class ItemScreen extends ConsumerWidget {
  const ItemScreen({super.key, required this.sku});

  final String sku;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(inventoryProvider).value?.bySku(sku);
    final navigator = ref.watch(navigatorProvider);

    return Scaffold(
      appBar: SiteAppBar(title: item?.name ?? 'Not found'),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_basket, size: 96),
            const SizedBox(height: 16),
            if (item != null) Text('Pick from bin ${item.bin}'),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: navigator.goBack,
              child: const Text('Back to list'),
            ),
          ],
        ),
      ),
    );
  }
}
