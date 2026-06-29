import 'package:flenx/flenx.dart';

/// Marca, menu e rodapé do portal de notícias.
const newsBrand = SiteBrand(label: 'Flenx News', homeHref: '/');

const newsLinks = [
  MenuLink(label: 'Início', href: '/'),
  MenuLink(label: 'Notícias', href: '/blog'),
  MenuLink(label: 'Categorias', href: '/blog/categoria'),
  MenuLink(label: 'Sobre', href: '/sobre'),
];

class NewsFooter extends StatelessComponent {
  const NewsFooter({super.key});

  @override
  Component build(BuildContext context) {
    return const FlenxFooter(
      brand: 'Flenx News',
      tagline: 'Portal de notícias de exemplo, feito com Flenx.',
      columns: [
        FlenxFooterColumn('Seções', [
          MenuLink(label: 'Todas as notícias', href: '/blog'),
          MenuLink(label: 'Categorias', href: '/blog/categoria'),
        ]),
        FlenxFooterColumn('Institucional', [
          MenuLink(label: 'Sobre', href: '/sobre'),
        ]),
      ],
      copyright: '© 2026 Flenx News. Feito com Dart, jaspr e Flutter.',
    );
  }
}
