import 'item_parser.dart';

/// One line of stock an app knows how to handle.
sealed class StockItem {
  const StockItem({required this.sku, required this.name, required this.bin});

  final String sku;
  final String name;

  /// Shelf location, for example `A-12-3`.
  final String bin;
}

final class PalletItem extends StockItem {
  const PalletItem({
    required super.sku,
    required super.name,
    required super.bin,
    required this.cases,
  });

  factory PalletItem.fromJson(Map<String, Object?> json) => PalletItem(
    sku: json['sku']! as String,
    name: json['name']! as String,
    bin: json['bin']! as String,
    cases: json['cases']! as int,
  );

  final int cases;
}

final class CartonItem extends StockItem {
  const CartonItem({
    required super.sku,
    required super.name,
    required super.bin,
    required this.units,
  });

  factory CartonItem.fromJson(Map<String, Object?> json) => CartonItem(
    sku: json['sku']! as String,
    name: json['name']! as String,
    bin: json['bin']! as String,
    units: json['units']! as int,
  );

  final int units;
}

final class LooseItem extends StockItem {
  const LooseItem({
    required super.sku,
    required super.name,
    required super.bin,
    required this.quantity,
  });

  factory LooseItem.fromJson(Map<String, Object?> json) => LooseItem(
    sku: json['sku']! as String,
    name: json['name']! as String,
    bin: json['bin']! as String,
    quantity: json['quantity']! as int,
  );

  final int quantity;
}

/// The inventory feed is a contract between the backend and every installed
/// binary. Items this binary cannot interpret are skipped, not fatal.
class Inventory {
  const Inventory(this.items);

  factory Inventory.fromJson(Map<String, Object?> json) {
    final raw = (json['items'] as List<Object?>? ?? const [])
        .cast<Map<String, Object?>>();
    return Inventory(raw.map(tryParseItem).nonNulls.toList());
  }

  final List<StockItem> items;

  StockItem? bySku(String sku) => items.where((i) => i.sku == sku).firstOrNull;
}
