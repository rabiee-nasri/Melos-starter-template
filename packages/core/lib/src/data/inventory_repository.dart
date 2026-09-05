import '../inventory/inventory.dart';
import 'api_client.dart';
import 'local_cache.dart';

class InventoryRepository {
  InventoryRepository(this._api, this._cache);

  final ApiClient _api;
  final LocalCache _cache;

  static const _key = 'inventory';
  static const _path = '/v1/inventory';

  /// Cache first, network second: every screen has something to render,
  /// and a handheld at the back of the warehouse with no signal still works.
  Stream<Inventory> watchInventory() async* {
    final cached = await _cache.readJson(_key);
    if (cached != null) yield Inventory.fromJson(cached);

    final fresh = await _api.getJson(_path);
    await _cache.writeJson(_key, fresh);
    yield Inventory.fromJson(fresh);
  }
}
