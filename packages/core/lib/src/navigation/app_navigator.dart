/// Shared code navigates through this interface. Each app implements it
/// against its own route table, so core never learns a route string.
abstract interface class AppNavigator {
  void openItem(String sku);
  void goBack();
}
