import 'package:receiving/main.dart';
import 'package:receiving/navigation/go_router_navigator.dart';
import 'package:receiving/router.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeApi implements ApiClient {
  @override
  Future<Map<String, Object?>> getJson(String path) async => {
    'items': [
      {
        'type': 'loose',
        'sku': 'x1',
        'name': 'From the fake API',
        'bin': 'A-1',
        'quantity': 3,
      },
    ],
  };
}

void main() {
  setUp(() {
    getIt
      ..registerSingleton<ApiClient>(_FakeApi())
      ..registerSingleton<LocalCache>(InMemoryCache())
      ..registerSingleton<AppNavigator>(GoRouterNavigator(router));
  });
  tearDown(getIt.reset);

  testWidgets('renders the stock list and opens an item', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ReceivingApp()));
    await tester.pumpAndSettle();

    expect(find.text('From the fake API'), findsOneWidget);

    await tester.tap(find.text('From the fake API'));
    await tester.pumpAndSettle();

    expect(find.text('Back to list'), findsOneWidget);
  });
}
