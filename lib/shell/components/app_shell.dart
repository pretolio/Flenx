import 'package:flutter/material.dart';

import '../models/app_notification.dart';
import '../models/app_user.dart';
import '../models/nav_item.dart';
import '../utils/shell_breakpoints.dart';
import 'sidebar.dart';
import 'top_bar.dart';

/// Shell de aplicação responsivo.
///
/// - **Desktop** (≥1024px): sidebar fixa à esquerda + top bar.
/// - **Tablet e mobile** (<1024px): sidebar vira **drawer** (hambúrguer); a
///   top bar continua sempre visível com notificações e menu de perfil.
class AppShell extends StatefulWidget {
  const AppShell({
    required this.user,
    required this.navItems,
    this.pages = const {},
    this.body,
    this.title = '',
    this.notifications = const [],
    this.onLogout,
    this.onNavigate,
    this.initialRoute,
    this.isDark = false,
    this.onToggleTheme,
    super.key,
  }) : assert(
         pages.length > 0 || body != null,
         'Forneça `pages` (rota→conteúdo) ou um `body`.',
       );

  final AppUser user;
  final List<NavItem> navItems;

  /// Mapa rota → construtor de conteúdo. O esqueleto (sidebar + top bar)
  /// permanece montado; ao navegar, **apenas o conteúdo troca**.
  final Map<String, WidgetBuilder> pages;

  /// Conteúdo fixo (usado quando [pages] está vazio).
  final Widget? body;

  final String title;
  final List<AppNotification> notifications;
  final VoidCallback? onLogout;
  final ValueChanged<String>? onNavigate;
  final String? initialRoute;

  /// Estado do tema e callback para alternar claro/escuro (opcional).
  final bool isDark;
  final VoidCallback? onToggleTheme;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialRoute;
  }

  void _select(NavItem item) {
    if (item.route == null) return;
    setState(() => _selected = item.route);
    widget.onNavigate?.call(item.route!);
  }

  /// Conteúdo atual — troca conforme a rota selecionada, mantendo o esqueleto.
  Widget get _content {
    final builder = _selected != null ? widget.pages[_selected] : null;
    final child = builder != null ? Builder(builder: builder) : widget.body;
    // A `key` por rota garante a troca limpa do conteúdo, sem remontar o shell.
    return KeyedSubtree(
      key: ValueKey(_selected ?? 'body'),
      child: child ?? const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDrawer = ShellBreakpoints.isDrawer(constraints.maxWidth);
        final sidebar = Sidebar(
          user: widget.user,
          items: widget.navItems,
          onSelect: _select,
          selectedRoute: _selected,
          onLogout: widget.onLogout,
        );

        // SelectionArea torna TODO o texto do shell selecionável por padrão na
        // web (no Flutter, texto não é selecionável sem isso).
        return SelectionArea(
          child: Scaffold(
            appBar: TopBar(
              user: widget.user,
              title: widget.title,
              notifications: widget.notifications,
              onLogout: widget.onLogout,
              isDark: widget.isDark,
              onToggleTheme: widget.onToggleTheme,
            ),
            drawer: isDrawer ? Drawer(child: sidebar) : null,
            body: isDrawer
                ? _content
                : Row(
                    children: [
                      SizedBox(width: 280, child: sidebar),
                      const VerticalDivider(width: 1),
                      Expanded(child: _content),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
