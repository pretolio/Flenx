import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';
import '../../site/models/menu_link.dart';

/// Uma coluna de links do rodapé.
class FlenxFooterColumn {
  const FlenxFooterColumn(this.title, this.links);
  final String title;
  final List<MenuLink> links;
}

/// Rodapé pronto: marca + frase + colunas de links + linha de copyright.
/// Tudo por parâmetros (Dart); o componente desenha o HTML por baixo.
class FlenxFooter extends StatelessComponent {
  const FlenxFooter({
    required this.brand,
    this.tagline,
    this.columns = const [],
    this.copyright,
    this.background = FlenxPalette.darkBg,
    this.id,
    super.key,
  });

  final String brand;
  final String? tagline;
  final List<FlenxFooterColumn> columns;
  final String? copyright;
  final String background;
  final String? id;

  Component _link(MenuLink l) => a(
        [.text(l.label)],
        href: l.href ?? '#',
        styles: Styles(raw: {
          'color': '#94a3b8',
          'text-decoration': 'none',
          'display': 'block',
          'margin-top': '8px',
        }),
      );

  @override
  Component build(BuildContext context) {
    return Component.element(
      tag: 'footer',
      id: id,
      styles: Styles(raw: {'background': background, 'color': '#cbd5e1', 'padding': '56px 24px 28px'}),
      children: [
        div(
          styles: Styles(raw: {'max-width': '1120px', 'margin': '0 auto'}),
          [
            div(
              styles: Styles(raw: {
                'display': 'flex',
                'flex-wrap': 'wrap',
                'gap': '40px',
                'justify-content': 'space-between',
              }),
              [
                div(styles: Styles(raw: {'max-width': '280px'}), [
                  div(
                      styles: Styles(raw: {
                        'font-weight': '800',
                        'font-size': '20px',
                        'color': '#fff',
                      }),
                      [.text(brand)]),
                  if (tagline != null)
                    p(styles: Styles(raw: {'margin': '10px 0 0', 'color': '#94a3b8'}),
                        [.text(tagline!)]),
                ]),
                for (final col in columns)
                  div([
                    div(
                        styles: Styles(raw: {
                          'font-weight': '700',
                          'color': '#fff',
                          'margin-bottom': '4px',
                        }),
                        [.text(col.title)]),
                    for (final l in col.links) _link(l),
                  ]),
              ],
            ),
            if (copyright != null)
              div(
                  styles: Styles(raw: {
                    'margin-top': '32px',
                    'padding-top': '20px',
                    'border-top': '1px solid ${FlenxPalette.darkBorder}',
                    'color': '#94a3b8',
                    'font-size': '14px',
                  }),
                  [.text(copyright!)]),
          ],
        ),
      ],
    );
  }
}
