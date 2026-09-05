import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('skips packaging types this binary does not know', () {
    final inventory = Inventory.fromJson({
      'items': [
        {
          'type': 'carton',
          'sku': 'c1',
          'name': 'Bolts',
          'bin': 'B-2',
          'units': 50,
        },
        {'type': 'drum', 'sku': 'd1', 'name': 'Oil', 'bin': 'B-3'},
      ],
    });

    expect(inventory.items.map((i) => i.sku), ['c1']);
    expect(inventory.items.single, isA<CartonItem>());
  });
}
