import 'package:flutter/material.dart';

import '../models/nav_item.dart';
import 'nav_tile.dart';

/// Item de menu expansível (com submenu), estilo accordion. Mostra os
/// [NavItem.children] ao expandir. Inicia expandido se um filho está selecionado.
class ExpandableNavTile extends StatelessWidget {
  const ExpandableNavTile({
    required this.item,
    required this.onSelect,
    this.selectedRoute,
    super.key,
  });

  final NavItem item;
  final ValueChanged<NavItem> onSelect;
  final String? selectedRoute;

  bool get _hasSelectedChild =>
      item.children.any((c) => c.route != null && c.route == selectedRoute);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(item.icon),
      title: Text(item.label),
      initiallyExpanded: _hasSelectedChild,
      childrenPadding: const EdgeInsets.only(left: 16),
      children: [
        for (final child in item.children)
          NavTile(
            item: child,
            onSelect: onSelect,
            dense: true,
            selected: child.route != null && child.route == selectedRoute,
          ),
      ],
    );
  }
}
