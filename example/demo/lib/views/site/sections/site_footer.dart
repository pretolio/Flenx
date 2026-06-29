import 'package:flenx/flenx.dart';

/// Rodapé do site do demo: usa o genérico [FlenxFooter] da lib, só passando o
/// conteúdo (marca, frase, colunas de links). Nada de HTML/CSS.
class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return const FlenxFooter(
      brand: 'Flenx',
      tagline: 'Framework Flutter estilo Next.js, em Dart.',
      columns: [
        FlenxFooterColumn('Produto', [
          MenuLink(label: 'Recursos', href: '/#recursos'),
          MenuLink(label: 'Blog', href: '/blog'),
          MenuLink(label: 'Admin', href: '/admin'),
        ]),
        FlenxFooterColumn('Empresa', [
          MenuLink(label: 'Sobre', href: '/about'),
          MenuLink(label: 'Contato', href: '/#contato'),
        ]),
      ],
      copyright: '© 2026 Flenx. Feito com Dart, jaspr e Flutter.',
    );
  }
}
