import 'package:go_router/go_router.dart';

import 'screens/item_screen.dart';
import 'screens/stock_list_screen.dart';

/// This app's route table. Nothing outside apps/stocktake knows these strings.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const StockListScreen(),
      routes: [
        GoRoute(
          path: 'item/:sku',
          builder: (context, state) =>
              ItemScreen(sku: state.pathParameters['sku']!),
        ),
      ],
    ),
  ],
);
