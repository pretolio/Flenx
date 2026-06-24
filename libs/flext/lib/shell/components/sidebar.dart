import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/nav_item.dart';
import 'logout_button.dart';
import 'nav_menu.dart';
import 'sidebar_header.dart';

/// Conteúdo da barra lateral: área de user/admin no topo, menu de navegação
/// (com itens clicáveis e expansíveis) e o botão "Sair" no rodapé.
///
/// É usada tanto como sidebar fixa (desktop) quanto dentro do drawer
/// (mobile/tablet).
class Sidebar extends StatelessWidget {
  const Sidebar({
    required this.user,
    required this.items,
    required this.onSelect,
    this.selectedRoute,
    this.onLogout,
    super.key,
  });

  final AppUser user;
  final List<NavItem> items;
  final ValueChanged<NavItem> onSelect;
  final String? selectedRoute;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          SidebarHeader(user: user),
          Expanded(
            child: NavMenu(
              items: items,
              onSelect: onSelect,
              selectedRoute: selectedRoute,
            ),
          ),
          const Divider(height: 1),
          SafeArea(top: false, child: LogoutButton(onLogout: onLogout)),
        ],
      ),
    );
  }
}
