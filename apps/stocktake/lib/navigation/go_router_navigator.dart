import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

/// Maps the shared AppNavigator interface onto this app's route table.
class GoRouterNavigator implements AppNavigator {
  GoRouterNavigator(this._router);

  final GoRouter _router;

  @override
  void openItem(String sku) => _router.push('/item/$sku');

  @override
  void goBack() => _router.pop();
}
