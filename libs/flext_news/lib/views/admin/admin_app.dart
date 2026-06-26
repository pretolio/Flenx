import 'package:flutter/material.dart';
import 'package:flext/shell.dart';

/// Admin do portal de notícias — só preenche as opções do [FlextAdminApp] da
/// lib (usuário, menu, páginas e dados). Reusa as telas prontas do kit.
class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  static const _user = AppUser(
    name: 'Redação Flext',
    role: 'Administrador',
    email: 'admin@flextnews.com',
  );

  static const _navItems = [
    NavItem(label: 'Dashboard', icon: Icons.dashboard_outlined, route: '/'),
    NavItem(
      label: 'Notícias',
      icon: Icons.article_outlined,
      route: '/posts',
      permission: AdminPermissions.manageContent,
    ),
    NavItem(
      label: 'Usuários',
      icon: Icons.people_outline,
      route: '/users',
      permission: AdminPermissions.manageUsers,
    ),
    NavItem(
      label: 'Tela inicial',
      icon: Icons.home_outlined,
      route: '/home',
      permission: AdminPermissions.editHome,
    ),
    NavItem(
      label: 'Configurações',
      icon: Icons.settings_outlined,
      route: '/settings',
      permission: AdminPermissions.settings,
    ),
  ];

  static const _stats = [
    DashboardStat(icon: Icons.article_outlined, label: 'Notícias', value: '8', trend: '+3 esta semana'),
    DashboardStat(icon: Icons.people_outline, label: 'Usuários', value: '12', trend: '+2'),
    DashboardStat(icon: Icons.visibility_outlined, label: 'Visitas', value: '9.540', trend: '+14%'),
    DashboardStat(icon: Icons.trending_up, label: 'Engajamento', value: '4m 12s', trend: '+8%'),
  ];

  static const _activity = [
    ActivityItem(icon: Icons.article_outlined, title: 'Notícia publicada', subtitle: '"IA no jornalismo" · há 1 h'),
    ActivityItem(icon: Icons.person_add_alt, title: 'Novo usuário', subtitle: 'editor@flextnews.com · há 3 h'),
    ActivityItem(icon: Icons.edit_outlined, title: 'Tela inicial atualizada', subtitle: 'hero alterado · hoje'),
    ActivityItem(icon: Icons.favorite_outline, title: 'Pico de acessos', subtitle: '/blog/economia-juros · hoje'),
  ];

  static const _usersConfig = ResourceConfig(
    title: 'Usuários',
    singular: 'usuário',
    titleKey: 'name',
    subtitleKey: 'email',
    listPath: '/api/users/list',
    createPath: '/api/users',
    updatePath: '/api/users/update',
    deletePath: '/api/users/delete',
    fields: [
      ResourceField('name', 'Nome', required: true, inTable: true),
      ResourceField('email', 'E-mail', required: true),
      ResourceField('role', 'Papel',
          kind: FieldKind.select, options: AdminPermissions.roleNames),
      ResourceField('active', 'Ativo', kind: FieldKind.boolean),
    ],
  );

  static const _homeFields = [
    SettingField('hero_title', 'Título de destaque'),
    SettingField('hero_subtitle', 'Subtítulo', multiline: true),
  ];

  @override
  Widget build(BuildContext context) {
    return FlextAdminApp(
      title: 'Flext News',
      user: _user,
      role: AdminPermissions.admin,
      navItems: _navItems,
      pages: {
        '/': (c) => const FlextDashboard(
              stats: _stats,
              activity: _activity,
              greeting: 'Olá, Redação 👋',
              subtitle: 'Aqui está um resumo do portal hoje.',
            ),
        '/posts': (c) => const BlogAdminPage(title: 'Notícias'),
        '/users': (c) => const FlextResourcePage(config: _usersConfig),
        '/home': (c) => const FlextSettingsPage(
              title: 'Tela inicial',
              fields: _homeFields,
            ),
        '/settings': (c) =>
            const SectionPlaceholder('Configurações', Icons.settings_outlined),
      },
    );
  }
}
