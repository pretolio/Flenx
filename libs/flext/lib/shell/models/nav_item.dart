import 'package:flutter/widgets.dart';

/// Item de navegação do menu. Pode ser clicável (com [route]/[onTap]) ou
/// expansível (quando tem [children] — submenu, estilo accordion).
class NavItem {
  const NavItem({
    required this.label,
    required this.icon,
    this.route,
    this.onTap,
    this.children = const [],
    this.badge,
    this.permission,
  });

  final String label;
  final IconData icon;

  /// Rota associada (para navegação por rota).
  final String? route;

  /// Ação direta ao clicar (alternativa a [route]).
  final VoidCallback? onTap;

  /// Subitens — se não vazio, o item vira expansível.
  final List<NavItem> children;

  /// Contador opcional exibido como badge (ex.: itens não lidos).
  final int? badge;

  /// Permissão exigida para ver o item (nula = sempre visível). Combina com o
  /// papel do usuário (ver `AppRole`/`FlextAdminApp.role`).
  final String? permission;

  bool get isExpandable => children.isNotEmpty;

  /// Cópia com novos [children] (usado ao filtrar submenus por permissão).
  NavItem withChildren(List<NavItem> items) => NavItem(
        label: label,
        icon: icon,
        route: route,
        onTap: onTap,
        children: items,
        badge: badge,
        permission: permission,
      );
}
