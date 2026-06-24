import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flext/shell/shell.dart';

const _user = AppUser(name: 'Gabriel Potenza', role: 'Administrador');

const _notifications = [
  AppNotification(title: 'A', message: 'm'),
  AppNotification(title: 'B', message: 'm'),
  AppNotification(title: 'C', message: 'm', read: true),
];

const _items = [
  NavItem(label: 'Dashboard', icon: Icons.dashboard, route: '/'),
  NavItem(label: 'Conteúdo', icon: Icons.folder, children: [
    NavItem(label: 'Categorias', icon: Icons.label, route: '/cats'),
    NavItem(label: 'Tags', icon: Icons.tag, route: '/tags'),
  ]),
];

Widget _app({VoidCallback? onLogout}) => MaterialApp(
      home: AppShell(
        title: 'Admin',
        user: _user,
        notifications: _notifications,
        navItems: _items,
        initialRoute: '/',
        onLogout: onLogout,
        body: const Text('CORPO'),
      ),
    );

Widget _appWithPages() => MaterialApp(
      home: AppShell(
        title: 'Admin',
        user: _user,
        navItems: _items,
        initialRoute: '/',
        pages: {
          '/': (c) => const Text('CONTEUDO DASHBOARD'),
          '/cats': (c) => const Text('CONTEUDO CATEGORIAS'),
        },
      ),
    );

void main() {
  group('AppShell responsivo', () {
    testWidgets('desktop: sidebar fixa visível, sem hambúrguer',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1300, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(find.text('Gabriel Potenza'), findsOneWidget); // header da sidebar
      expect(find.byTooltip('Open navigation menu'), findsNothing);
    });

    testWidgets('mobile: vira drawer, hambúrguer abre a sidebar',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      // Sidebar escondida no drawer.
      expect(find.text('Gabriel Potenza'), findsNothing);
      final hamburger = find.byTooltip('Open navigation menu');
      expect(hamburger, findsOneWidget);

      await tester.tap(hamburger);
      await tester.pumpAndSettle();
      expect(find.text('Gabriel Potenza'), findsOneWidget);
    });
  });

  group('Menu', () {
    testWidgets('item expansível mostra os filhos ao tocar', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1300, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(find.text('Categorias'), findsNothing);
      await tester.tap(find.text('Conteúdo'));
      await tester.pumpAndSettle();
      expect(find.text('Categorias'), findsOneWidget);
      expect(find.text('Tags'), findsOneWidget);
    });

    testWidgets('troca o conteúdo mantendo o esqueleto (layout persistente)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1300, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_appWithPages());
      await tester.pumpAndSettle();

      // Conteúdo inicial + esqueleto presentes.
      expect(find.text('CONTEUDO DASHBOARD'), findsOneWidget);
      expect(find.text('Gabriel Potenza'), findsOneWidget);

      // Abre o expansível e seleciona um filho.
      await tester.tap(find.text('Conteúdo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Categorias'));
      await tester.pumpAndSettle();

      // Conteúdo trocou; sidebar (esqueleto) continua montada.
      expect(find.text('CONTEUDO CATEGORIAS'), findsOneWidget);
      expect(find.text('CONTEUDO DASHBOARD'), findsNothing);
      expect(find.text('Gabriel Potenza'), findsOneWidget);
    });

    testWidgets('botão Sair da sidebar dispara onLogout', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1300, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      var saiu = false;
      await tester.pumpWidget(_app(onLogout: () => saiu = true));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sair'));
      await tester.pumpAndSettle();
      expect(saiu, isTrue);
    });
  });

  group('Top bar', () {
    testWidgets('badge de notificações mostra a contagem não lida',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget); // 2 de 3 não lidas
    });

    testWidgets('menu de perfil abre e Sair dispara onLogout', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      var saiu = false;
      await tester.pumpWidget(_app(onLogout: () => saiu = true));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ProfileMenu));
      await tester.pumpAndSettle();
      expect(find.text('Configurações'), findsOneWidget);

      await tester.tap(find.text('Sair'));
      await tester.pumpAndSettle();
      expect(saiu, isTrue);
    });
  });
}

