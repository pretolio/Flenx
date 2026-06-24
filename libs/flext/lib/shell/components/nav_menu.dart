import 'package:flutter/material.dart';

import '../models/nav_item.dart';
import 'expandable_nav_tile.dart';
import 'nav_tile.dart';

/// Lista de navegação: renderiza cada [NavItem] como item clicável ou
/// expansível, conforme tenha filhos.
class NavMenu extends StatelessWidget {
  const NavMenu({
    required this.items,
    required this.onSelect,
    this.selectedRoute,
    super.key,
  });

  final List<NavItem> items;
  final ValueChanged<NavItem> onSelect;
  final String? selectedRoute;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        for (final item in items)
          if (item.isExpandable)
            ExpandableNavTile(
              item: item,
              onSelect: onSelect,
              selectedRoute: selectedRoute,
            )
          else
            NavTile(
              item: item,
              onSelect: onSelect,
              selected: item.route != null && item.route == selectedRoute,
            ),
      ],
    );
  }
}
