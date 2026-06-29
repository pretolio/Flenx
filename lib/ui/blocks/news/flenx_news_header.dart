import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../flenx_palette.dart';
import '../../../site/models/menu_link.dart';
import 'flenx_news_styles.dart';

/// Cabeçalho de portal de notícias (estilo G1): barra branca fixa com logo
/// (duas palavras) e, abaixo, a faixa de editorias com rolagem no mobile.
/// A cor do logo e dos hovers vem de `var(--primary)` (defina no [FlenxPage]).
class FlenxNewsHeader extends StatelessComponent {
  const FlenxNewsHeader({
    required this.brandPrimary,
    required this.links,
    this.brandSecondary,
    this.liveLabel = 'AO VIVO',
    this.homeHref = '/',
    super.key,
  });

  /// Primeira parte do logo (ex.: `flenx`).
  final String brandPrimary;

  /// Segunda parte do logo, em destaque leve (ex.: `news`). Opcional.
  final String? brandSecondary;

  final List<MenuLink> links;

  /// Selo "ao vivo" à direita. `null` = oculto.
  final String? liveLabel;

  final String homeHref;

  @override
  Component build(BuildContext context) {
    return header(
      styles: Styles(raw: {
        'position': 'sticky',
        'top': '0',
        'z-index': '50',
        'background': '#ffffff',
        'border-bottom': '1px solid ${FlenxPalette.border}',
        'box-shadow': '0 1px 4px rgba(0,0,0,.04)',
      }),
      [
        Component.element(tag: 'style', children: [RawText(flenxNewsCss)]),
        div(
          styles: Styles(raw: {
            'max-width': '1120px',
            'margin': '0 auto',
            'padding': '0 16px',
          }),
          [
            div(
              styles: Styles(raw: {
                'display': 'flex',
                'align-items': 'center',
                'justify-content': 'space-between',
                'padding': '10px 0',
              }),
              [
                a(href: homeHref, classes: 'fnews-logo', [
                  span(
                    styles: Styles(raw: {'font-size': '22px'}),
                    [Component.text(brandPrimary)],
                  ),
                  if (brandSecondary != null)
                    span(
                      styles: Styles(raw: {'font-size': '13px', 'opacity': '.85'}),
                      [Component.text(brandSecondary!)],
                    ),
                ]),
                if (liveLabel != null) _live(liveLabel!),
              ],
            ),
            nav(
              classes: 'fnews-edit',
              styles: Styles(raw: {'border-top': '1px solid ${FlenxPalette.border}'}),
              [
                for (final l in links)
                  a(href: l.href ?? '#', [Component.text(l.label)]),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Component _live(String label) => span(
        styles: Styles(raw: {
          'display': 'inline-flex',
          'align-items': 'center',
          'gap': '6px',
          'color': 'var(--primary)',
          'font-size': '12px',
          'font-weight': '800',
          'letter-spacing': '.05em',
        }),
        [
          span(styles: Styles(raw: {
            'width': '8px',
            'height': '8px',
            'border-radius': '50%',
            'background': 'var(--primary)',
            'display': 'inline-block',
          }), []),
          Component.text(label),
        ],
      );
}
