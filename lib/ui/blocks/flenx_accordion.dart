import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';
import 'flenx_accordion_item.dart';

export 'flenx_accordion_item.dart';

/// Lista acordeão — itens expansíveis com animação suave (CSS puro, sem JS).
///
/// ```dart
/// FlenxAccordion(
///   items: [
///     FlenxAccordionItem('Como funciona?', 'Resposta aqui...', open: true),
///     FlenxAccordionItem('Qual o prazo?', 'Em até 24h.'),
///   ],
/// )
/// ```
class FlenxAccordion extends StatelessComponent {
  const FlenxAccordion({
    required this.items,
    this.accentColor = FlenxPalette.primary,
    super.key,
  });

  final List<FlenxAccordionItem> items;

  /// Cor da linha de destaque e do ícone ativo.
  final String accentColor;

  static const _css = '''
.facc details{border-bottom:1px solid #e2e8f0}
.facc details:first-child{border-top:1px solid #e2e8f0}
.facc summary{list-style:none;display:flex;align-items:center;justify-content:space-between;gap:12px;padding:18px 4px;cursor:pointer;font-weight:600;font-size:16px;color:#0f172a;user-select:none}
.facc summary::-webkit-details-marker{display:none}
.facc summary::after{content:'+';font-size:22px;font-weight:400;color:#94a3b8;transition:transform .25s ease,color .25s ease;flex-shrink:0}
.facc details[open] summary::after{transform:rotate(45deg)}
.facc .facc-body{display:grid;grid-template-rows:0fr;transition:grid-template-rows .3s ease}
.facc details[open] .facc-body{grid-template-rows:1fr}
.facc .facc-inner{overflow:hidden}
.facc .facc-text{padding:0 4px 18px;color:#64748b;line-height:1.65;font-size:15px}
''';

  String get _accentCss =>
      '.facc details[open] summary{color:$accentColor}'
      '.facc details[open] summary::after{color:$accentColor}';

  @override
  Component build(BuildContext context) {
    return div(classes: 'facc', [
      Component.element(tag: 'style', children: [RawText('$_css$_accentCss')]),
      for (final item in items)
        Component.element(
          tag: 'details',
          attributes: item.open ? {'open': ''} : {},
          children: [
            Component.element(
              tag: 'summary',
              children: [.text(item.title)],
            ),
            div(classes: 'facc-body', [
              div(classes: 'facc-inner', [
                div(classes: 'facc-text', [.text(item.body)]),
              ]),
            ]),
          ],
        ),
    ]);
  }
}
