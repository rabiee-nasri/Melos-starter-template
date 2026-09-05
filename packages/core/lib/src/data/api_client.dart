/// Everything that comes over the network enters core through this seam.
abstract interface class ApiClient {
  Future<Map<String, Object?>> getJson(String path);
}
