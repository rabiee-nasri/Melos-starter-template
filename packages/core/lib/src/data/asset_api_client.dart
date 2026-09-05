import 'dart:convert';

import 'package:flutter/services.dart';

import 'api_client.dart';

/// Stand-in for a real HTTP client. Serves bundled JSON assets by path,
/// so the demo apps run without a backend.
class AssetApiClient implements ApiClient {
  AssetApiClient(this._routes, {AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  /// Request path to asset name, for example `/v1/inventory` to
  /// `assets/inventory.json`.
  final Map<String, String> _routes;
  final AssetBundle _bundle;

  @override
  Future<Map<String, Object?>> getJson(String path) async {
    final asset = _routes[path];
    if (asset == null) throw ArgumentError.value(path, 'path', 'No asset');
    final text = await _bundle.loadString(asset);
    return jsonDecode(text) as Map<String, Object?>;
  }
}
