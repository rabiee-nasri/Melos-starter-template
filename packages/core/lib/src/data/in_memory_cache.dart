import 'local_cache.dart';

/// Stand-in for on-device storage. Lives as long as the process.
class InMemoryCache implements LocalCache {
  final _store = <String, Map<String, Object?>>{};

  @override
  Future<Map<String, Object?>?> readJson(String key) async => _store[key];

  @override
  Future<void> writeJson(String key, Map<String, Object?> value) async {
    _store[key] = value;
  }
}
