import 'package:flutter/material.dart';

/// One theme, three seed colours. This is what makes three differently
/// shaped apps read as one product.
abstract final class AppTheme {
  static ThemeData light(Color seed) => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seed),
    cardTheme: const CardThemeData(margin: EdgeInsets.zero),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );
}
