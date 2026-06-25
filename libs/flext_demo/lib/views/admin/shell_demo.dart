import 'package:flutter/material.dart';
import 'package:flext/shell.dart'; // AppShell, FlextDashboard, SectionPlaceholder...

import '../../viewmodels/admin_view_model.dart';

/// View raiz do painel admin (MVVM): observa o [AdminViewModel] e monta o
/// shell do Flext com tema claro/escuro. Estado e dados ficam no ViewModel.
class ShellDemo extends StatefulWidget {
  const ShellDemo({super.key});

  @override
  State<ShellDemo> createState() => _ShellDemoState();
}

class _ShellDemoState extends State<ShellDemo> {
  final AdminViewModel _vm = AdminViewModel();

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: FlextAdminTheme.light(),
        darkTheme: FlextAdminTheme.dark(),
        themeMode: _vm.themeMode,
        home: AppShell(
          title: 'Flext Admin',
          user: _vm.user,
          notifications: _vm.notifications,
          navItems: _vm.navItems,
          initialRoute: '/',
          isDark: _vm.isDark,
          onToggleTheme: _vm.toggleTheme,
          onLogout: () {},
          pages: {
            '/': (c) => FlextDashboard(
                  stats: _vm.stats,
                  activity: _vm.activity,
                  greeting: 'Olá, Gabriel 👋',
                  subtitle: 'Aqui está um resumo do seu site hoje.',
                ),
            '/posts': (c) =>
                const SectionPlaceholder('Posts', Icons.article_outlined),
            '/cats': (c) =>
                const SectionPlaceholder('Categorias', Icons.label_outline),
            '/tags': (c) => const SectionPlaceholder('Tags', Icons.tag),
            '/leads': (c) =>
                const SectionPlaceholder('Leads', Icons.mail_outline),
            '/users': (c) =>
                const SectionPlaceholder('Usuários', Icons.people_outline),
            '/settings': (c) => const SectionPlaceholder(
                'Configurações', Icons.settings_outlined),
          },
        ),
      ),
    );
  }
}
