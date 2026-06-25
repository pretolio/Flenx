import 'package:flutter/material.dart';
import 'package:flext/shell.dart'; // AppUser, NavItem, DashboardStat, ActivityItem

/// ViewModel do painel admin (MVVM): estado de tema (claro/escuro) + os dados
/// que a View consome. A View (ShellDemo) escuta via [ChangeNotifier].
class AdminViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  final AppUser user = const AppUser(
    name: 'Gabriel Potenza',
    role: 'Administrador',
    email: 'admin@flext.dev',
  );

  final List<AppNotification> notifications = const [
    AppNotification(title: 'Novo comentário', message: 'em "SSR no Flutter"'),
    AppNotification(title: 'Build concluído', message: 'deploy publicado'),
    AppNotification(title: 'Backup', message: 'feito com sucesso', read: true),
  ];

  final List<NavItem> navItems = const [
    NavItem(label: 'Dashboard', icon: Icons.dashboard_outlined, route: '/'),
    NavItem(label: 'Posts', icon: Icons.article_outlined, route: '/posts', badge: 3),
    NavItem(label: 'Conteúdo', icon: Icons.folder_outlined, children: [
      NavItem(label: 'Categorias', icon: Icons.label_outline, route: '/cats'),
      NavItem(label: 'Tags', icon: Icons.tag, route: '/tags'),
    ]),
    NavItem(label: 'Leads', icon: Icons.mail_outline, route: '/leads', badge: 12),
    NavItem(label: 'Usuários', icon: Icons.people_outline, route: '/users'),
    NavItem(label: 'Configurações', icon: Icons.settings_outlined, route: '/settings'),
  ];

  final List<DashboardStat> stats = const [
    DashboardStat(icon: Icons.article_outlined, label: 'Posts', value: '6', trend: '+2 este mês'),
    DashboardStat(icon: Icons.mail_outline, label: 'Leads', value: '128', trend: '+18%'),
    DashboardStat(icon: Icons.visibility_outlined, label: 'Visitas', value: '4.230', trend: '+9%'),
    DashboardStat(icon: Icons.people_outline, label: 'Inscritos', value: '340', trend: '+24'),
  ];

  final List<ActivityItem> activity = const [
    ActivityItem(icon: Icons.comment_outlined, title: 'Novo lead capturado', subtitle: 'ana@email.com · há 5 min'),
    ActivityItem(icon: Icons.article_outlined, title: 'Post publicado', subtitle: '"SSR no Flutter" · há 2 h'),
    ActivityItem(icon: Icons.person_add_alt, title: 'Novo inscrito', subtitle: 'joao@email.com · há 3 h'),
    ActivityItem(icon: Icons.favorite_outline, title: 'Pico de acessos', subtitle: '/blog/seo-automatico · hoje'),
  ];
}
