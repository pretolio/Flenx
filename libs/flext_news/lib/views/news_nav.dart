import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

/// Marca, menu e rodapé do portal de notícias.
const newsBrand = SiteBrand(label: 'Flext News', homeHref: '/');

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
    return const FlextFooter(
      brand: 'Flext News',
      tagline: 'Portal de notícias de exemplo, feito com Flext.',
      columns: [
        FlextFooterColumn('Seções', [
          MenuLink(label: 'Todas as notícias', href: '/blog'),
          MenuLink(label: 'Categorias', href: '/blog/categoria'),
        ]),
        FlextFooterColumn('Institucional', [
          MenuLink(label: 'Sobre', href: '/sobre'),
        ]),
      ],
      copyright: '© 2026 Flext News. Feito com Dart, jaspr e Flutter.',
    );
  }
}
