import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../flenx_palette.dart';
import '../../../site/models/menu_link.dart';

/// Bloco "Mais lidas" (estilo G1): lista numerada com números na cor primária.
class FlenxMostRead extends StatelessComponent {
  const FlenxMostRead(this.items, {this.title = 'Mais lidas', super.key});

  final List<MenuLink> items;
  final String title;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fnews-mr', [
      div(styles: Styles(raw: {
        'font-size': '15px',
        'font-weight': '800',
        'color': FlenxPalette.ink,
        'text-transform': 'uppercase',
        'letter-spacing': '.04em',
        'border-bottom': '3px solid var(--primary)',
        'padding-bottom': '8px',
        'margin-bottom': '4px',
      }), [Component.text(title)]),
      for (var i = 0; i < items.length; i++) _item(i + 1, items[i]),
    ]);
  }

  Component _item(int n, MenuLink m) => div(
        styles: Styles(raw: {
          'display': 'flex',
          'gap': '12px',
          'align-items': 'flex-start',
          'padding': '14px 0',
          'border-bottom': '1px solid ${FlenxPalette.border}',
        }),
        [
          span(styles: Styles(raw: {
            'color': 'var(--primary)',
            'font-size': '26px',
            'font-weight': '900',
            'line-height': '1',
            'min-width': '24px',
          }), [Component.text('$n')]),
          a(href: m.href ?? '#', [Component.text(m.label)]),
        ],
      );
}
