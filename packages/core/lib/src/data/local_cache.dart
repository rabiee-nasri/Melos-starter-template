/// Everything that survives a restart lives behind this seam.
abstract interface class LocalCache {
  Future<Map<String, Object?>?> readJson(String key);
  Future<void> writeJson(String key, Map<String, Object?> value);
}
