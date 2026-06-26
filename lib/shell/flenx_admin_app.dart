import 'package:flutter/material.dart';

import 'admin/app_permission.dart';
import 'components/app_shell.dart';
import 'flenx_admin_theme.dart';
import 'models/app_notification.dart';
import 'models/app_user.dart';
import 'models/nav_item.dart';

/// App de admin pronto — você só preenche as opções (igual ao [AppShell]):
/// usuário, notificações, itens de menu e as páginas (rota → conteúdo). Já vem
/// com tema claro/escuro e o botão de alternar funcionando. Use dentro de uma
/// ilha Flutter (`FlutterIsland`) na rota `/admin`.
class FlenxAdminApp extends StatefulWidget {
  const FlenxAdminApp({
    required this.user,
    required this.navItems,
    required this.pages,
    this.title = 'Admin',
    this.notifications = const [],
    this.initialRoute = '/',
    this.onLogout,
    this.role,
    super.key,
  });

  final AppUser user;
  final List<NavItem> navItems;

  /// Rota → conteúdo (widget). O shell troca só o conteúdo ao navegar.
  final Map<String, WidgetBuilder> pages;

  final String title;
  final List<AppNotification> notifications;
  final String initialRoute;
  final VoidCallback? onLogout;

  /// Papel do usuário logado. Se informado, itens de menu com `permission` que
  /// o papel não possui são escondidos (controle de acesso por papel).
  final AppRole? role;

  @override
  State<FlenxAdminApp> createState() => _FlenxAdminAppState();
}

class _FlenxAdminAppState extends State<FlenxAdminApp> {
  ThemeMode _mode = ThemeMode.light;

  void _toggle() => setState(
      () => _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  /// Filtra os itens (e subitens) que o papel atual pode acessar.
  List<NavItem> get _visibleNav {
    final role = widget.role;
    if (role == null) return widget.navItems;
    final out = <NavItem>[];
    for (final item in widget.navItems) {
      if (!role.can(item.permission)) continue;
      if (item.isExpandable) {
        final kids =
            item.children.where((c) => role.can(c.permission)).toList();
        if (kids.isEmpty && item.route == null) continue;
        out.add(item.withChildren(kids));
      } else {
        out.add(item);
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlenxAdminTheme.light(),
      darkTheme: FlenxAdminTheme.dark(),
      themeMode: _mode,
      home: AppShell(
        title: widget.title,
        user: widget.user,
        notifications: widget.notifications,
        navItems: _visibleNav,
        initialRoute: widget.initialRoute,
        isDark: _mode == ThemeMode.dark,
        onToggleTheme: _toggle,
        onLogout: widget.onLogout ?? () {},
        pages: widget.pages,
      ),
    );
  }
}
