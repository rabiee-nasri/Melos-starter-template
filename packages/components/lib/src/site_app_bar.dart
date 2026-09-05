import 'package:flutter/material.dart';

class SiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SiteAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      title: Text(title),
      backgroundColor: scheme.primaryContainer,
      foregroundColor: scheme.onPrimaryContainer,
      centerTitle: true,
    );
  }
}
