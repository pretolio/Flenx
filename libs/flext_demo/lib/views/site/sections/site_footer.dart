import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

/// Rodapé do site do demo: usa o genérico [FlextFooter] da lib, só passando o
/// conteúdo (marca, frase, colunas de links). Nada de HTML/CSS.
class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return const FlextFooter(
      brand: 'Flext',
      tagline: 'Framework Flutter estilo Next.js, em Dart.',
      columns: [
        FlextFooterColumn('Produto', [
          MenuLink(label: 'Recursos', href: '/#recursos'),
          MenuLink(label: 'Blog', href: '/blog'),
          MenuLink(label: 'Admin', href: '/admin'),
        ]),
        FlextFooterColumn('Empresa', [
          MenuLink(label: 'Sobre', href: '/about'),
          MenuLink(label: 'Contato', href: '/#contato'),
        ]),
      ],
      copyright: '© 2026 Flext. Feito com Dart, jaspr e Flutter.',
    );
  }
}
