import 'inventory.dart';

/// Old binaries meet new data. Unknown packaging types are skipped so one
/// new type on the backend never empties the list for old installs.
StockItem? tryParseItem(Map<String, Object?> json) {
  return switch (json['type']) {
    'pallet' => PalletItem.fromJson(json),
    'carton' => CartonItem.fromJson(json),
    'loose' => LooseItem.fromJson(json),
    // Unknown type: this binary predates the data.
    // Skip the item, keep the inventory.
    _ => null,
  };
}
