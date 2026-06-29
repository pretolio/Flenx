import 'package:flenx/flenx.dart';

/// Marca, menu e rodapé compartilhados da loja (fonte única).
const shopBrand = SiteBrand(label: 'Flenx Store', homeHref: '/');

const shopLinks = [
  MenuLink(label: 'Início', href: '/'),
  MenuLink(label: 'Produtos', href: '/produtos'),
  MenuLink(label: 'Carrinho', href: '/carrinho'),
  MenuLink(label: 'Contato', href: '/#contato'),
];

const shopLogin = [LoginOption(label: 'Minha conta', href: '/conta')];

/// Rodapé da loja (usa o FlenxFooter do kit).
class ShopFooter extends StatelessComponent {
  const ShopFooter({super.key});

  @override
  Component build(BuildContext context) {
    return const FlenxFooter(
      brand: 'Flenx Store',
      tagline: 'Loja de exemplo feita com Flenx — só Dart.',
      columns: [
        FlenxFooterColumn('Loja', [
          MenuLink(label: 'Produtos', href: '/produtos'),
          MenuLink(label: 'Início', href: '/'),
        ]),
        FlenxFooterColumn('Ajuda', [
          MenuLink(label: 'Contato', href: '/#contato'),
        ]),
      ],
      copyright: '© 2026 Flenx Store. Feito com Dart, jaspr e Flutter.',
    );
  }
}
