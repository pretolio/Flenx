import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

/// Marca, menu e rodapé compartilhados da loja (fonte única).
const shopBrand = SiteBrand(label: 'Flext Store', homeHref: '/');

const shopLinks = [
  MenuLink(label: 'Início', href: '/'),
  MenuLink(label: 'Produtos', href: '/produtos'),
  MenuLink(label: 'Carrinho', href: '/carrinho'),
  MenuLink(label: 'Contato', href: '/#contato'),
];

const shopLogin = [LoginOption(label: 'Minha conta', href: '/conta')];

/// Rodapé da loja (usa o FlextFooter do kit).
class ShopFooter extends StatelessComponent {
  const ShopFooter({super.key});

  @override
  Component build(BuildContext context) {
    return const FlextFooter(
      brand: 'Flext Store',
      tagline: 'Loja de exemplo feita com Flext — só Dart.',
      columns: [
        FlextFooterColumn('Loja', [
          MenuLink(label: 'Produtos', href: '/produtos'),
          MenuLink(label: 'Início', href: '/'),
        ]),
        FlextFooterColumn('Ajuda', [
          MenuLink(label: 'Contato', href: '/#contato'),
        ]),
      ],
      copyright: '© 2026 Flext Store. Feito com Dart, jaspr e Flutter.',
    );
  }
}
