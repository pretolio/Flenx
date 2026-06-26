import 'package:flutter/material.dart';
import 'package:flenx/shell.dart';

/// Admin do demo — só preenche as opções do [FlenxAdminApp] da lib.
/// Para criar o seu, copie isto e troque usuário, menu, páginas e dados.
class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  static const _user = AppUser(
    name: 'Gabriel Potenza',
    role: 'Administrador',
    email: 'admin@flenx.dev',
  );

  static const _notifications = [
    AppNotification(title: 'Novo comentário', message: 'em "SSR no Flutter"'),
    AppNotification(title: 'Build concluído', message: 'deploy publicado'),
    AppNotification(title: 'Backup', message: 'feito com sucesso', read: true),
  ];

  static const _navItems = [
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

  static const _stats = [
    DashboardStat(icon: Icons.article_outlined, label: 'Posts', value: '6', trend: '+2 este mês'),
    DashboardStat(icon: Icons.mail_outline, label: 'Leads', value: '128', trend: '+18%'),
    DashboardStat(icon: Icons.visibility_outlined, label: 'Visitas', value: '4.230', trend: '+9%'),
    DashboardStat(icon: Icons.people_outline, label: 'Inscritos', value: '340', trend: '+24'),
  ];

  static const _activity = [
    ActivityItem(icon: Icons.comment_outlined, title: 'Novo lead capturado', subtitle: 'ana@email.com · há 5 min'),
    ActivityItem(icon: Icons.article_outlined, title: 'Post publicado', subtitle: '"SSR no Flutter" · há 2 h'),
    ActivityItem(icon: Icons.person_add_alt, title: 'Novo inscrito', subtitle: 'joao@email.com · há 3 h'),
    ActivityItem(icon: Icons.favorite_outline, title: 'Pico de acessos', subtitle: '/blog/seo-automatico · hoje'),
  ];

  @override
  Widget build(BuildContext context) {
    return FlenxAdminApp(
      title: 'Flenx Admin',
      user: _user,
      notifications: _notifications,
      navItems: _navItems,
      pages: {
        '/': (c) => const FlenxDashboard(
              stats: _stats,
              activity: _activity,
              greeting: 'Olá, Gabriel 👋',
              subtitle: 'Aqui está um resumo do seu site hoje.',
            ),
        '/posts': (c) => BlogAdminPage(title: 'Posts', defaultAuthor: _user.name),
        '/cats': (c) => const SectionPlaceholder('Categorias', Icons.label_outline),
        '/tags': (c) => const SectionPlaceholder('Tags', Icons.tag),
        '/leads': (c) => const SectionPlaceholder('Leads', Icons.mail_outline),
        '/users': (c) => const SectionPlaceholder('Usuários', Icons.people_outline),
        '/settings': (c) =>
            const SectionPlaceholder('Configurações', Icons.settings_outlined),
      },
    );
  }
}
