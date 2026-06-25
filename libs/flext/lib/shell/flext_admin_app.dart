import 'package:flutter/material.dart';

import 'components/app_shell.dart';
import 'flext_admin_theme.dart';
import 'models/app_notification.dart';
import 'models/app_user.dart';
import 'models/nav_item.dart';

/// App de admin pronto — você só preenche as opções (igual ao [AppShell]):
/// usuário, notificações, itens de menu e as páginas (rota → conteúdo). Já vem
/// com tema claro/escuro e o botão de alternar funcionando. Use dentro de uma
/// ilha Flutter (`FlutterIsland`) na rota `/admin`.
class FlextAdminApp extends StatefulWidget {
  const FlextAdminApp({
    required this.user,
    required this.navItems,
    required this.pages,
    this.title = 'Admin',
    this.notifications = const [],
    this.initialRoute = '/',
    this.onLogout,
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

  @override
  State<FlextAdminApp> createState() => _FlextAdminAppState();
}

class _FlextAdminAppState extends State<FlextAdminApp> {
  ThemeMode _mode = ThemeMode.light;

  void _toggle() => setState(
      () => _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlextAdminTheme.light(),
      darkTheme: FlextAdminTheme.dark(),
      themeMode: _mode,
      home: AppShell(
        title: widget.title,
        user: widget.user,
        notifications: widget.notifications,
        navItems: widget.navItems,
        initialRoute: widget.initialRoute,
        isDark: _mode == ThemeMode.dark,
        onToggleTheme: _toggle,
        onLogout: widget.onLogout ?? () {},
        pages: widget.pages,
      ),
    );
  }
}
