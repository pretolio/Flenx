import 'package:jaspr_test/jaspr_test.dart';
import 'package:flext/site/site.dart';

void main() {
  group('SiteHeader (institucional)', () {
    testComponents('renderiza logo, menus, dropdown e botão de login',
        (tester) async {
      tester.pumpComponent(const SiteHeader(
        brand: SiteBrand(label: 'Flext', homeHref: '/'),
        links: [
          MenuLink(label: 'Início', href: '/'),
          MenuLink(label: 'Produtos', children: [
            MenuLink(label: 'Blog', href: '/blog'),
          ]),
        ],
        loginLabel: 'Entrar',
        loginOptions: [LoginOption(label: 'Criar conta', href: '/signup')],
      ));

      expect(find.text('Flext'), findsOneComponent); // logo (link home)
      expect(find.text('Início'), findsOneComponent); // link simples
      expect(find.text('Produtos'), findsOneComponent); // pai do dropdown
      expect(find.text('Blog'), findsOneComponent); // filho do dropdown (no DOM)
      expect(find.text('Entrar'), findsOneComponent); // botão login
      expect(find.text('Criar conta'), findsOneComponent); // opção de login
    });

    testComponents('sem opções, login é link simples', (tester) async {
      tester.pumpComponent(const SiteHeader(
        brand: SiteBrand(label: 'Flext'),
        links: [MenuLink(label: 'Início', href: '/')],
        loginLabel: 'Entrar',
        loginHref: '/login',
      ));
      expect(find.text('Entrar'), findsOneComponent);
    });
  });
}

