import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeApi implements ApiClient {
  _FakeApi(this.response);
  final Map<String, Object?> response;
  int calls = 0;

  @override
  Future<Map<String, Object?>> getJson(String path) async {
    calls++;
    return response;
  }
}

Map<String, Object?> _inventory(List<String> names) => {
  'items': [
    for (final (i, n) in names.indexed)
      {'type': 'loose', 'sku': '$i', 'name': n, 'bin': 'A-1', 'quantity': 1},
  ],
};

void main() {
  test('yields cache first, then network, and refreshes the cache', () async {
    final cache = InMemoryCache();
    await cache.writeJson('inventory', _inventory(['stale']));
    final api = _FakeApi(_inventory(['fresh']));

    final emitted = await InventoryRepository(
      api,
      cache,
    ).watchInventory().toList();

    expect(emitted.map((i) => i.items.single.name), ['stale', 'fresh']);
    expect(api.calls, 1);
    expect((await cache.readJson('inventory'))!, _inventory(['fresh']));
  });

  test('yields network only when the cache is empty', () async {
    final api = _FakeApi(_inventory(['fresh']));

    final emitted = await InventoryRepository(
      api,
      InMemoryCache(),
    ).watchInventory().toList();

    expect(emitted.map((i) => i.items.single.name), ['fresh']);
  });
}
