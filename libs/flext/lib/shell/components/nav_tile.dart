import 'package:flutter/material.dart';

import '../models/nav_item.dart';

/// Item de menu clicável (folha). Seleção em pílula arredondada com a cor da
/// marca; fecha o drawer ao tocar em layouts mobile/tablet.
class NavTile extends StatelessWidget {
  const NavTile({
    required this.item,
    required this.onSelect,
    this.selected = false,
    this.dense = false,
    super.key,
  });

  final NavItem item;
  final ValueChanged<NavItem> onSelect;
  final bool selected;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        dense: dense,
        selected: selected,
        selectedColor: scheme.primary,
        selectedTileColor: scheme.primary.withValues(alpha: 0.10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
        leading: Icon(item.icon, size: 22),
        title: Text(
          item.label,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        trailing:
            item.badge != null ? Badge(label: Text('${item.badge}')) : null,
        onTap: () {
          onSelect(item);
          item.onTap?.call();
          final scaffold = Scaffold.maybeOf(context);
          if (scaffold?.hasDrawer ?? false) scaffold!.closeDrawer();
        },
      ),
    );
  }
}
