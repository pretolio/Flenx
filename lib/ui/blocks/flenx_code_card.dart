import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';

/// Cartão de código (estilo "janela de editor") — você passa só o texto do
/// código; o componente desenha a janela. Nada de HTML/CSS da sua parte.
class FlenxCodeCard extends StatelessComponent {
  const FlenxCodeCard(this.code, {super.key});

  final String code;

  @override
  Component build(BuildContext context) {
    Component dot(String color) => div(
        styles: Styles(raw: {
          'width': '11px',
          'height': '11px',
          'border-radius': '50%',
          'background': color,
        }),
        const []);

    return div(
      styles: Styles(raw: {
        'background': FlenxPalette.darkBg,
        'border-radius': '14px',
        'padding': '16px',
        'box-shadow': '0 20px 50px rgba(0,0,0,.35)',
        'max-width': '460px',
        'width': '100%',
      }),
      [
        div(
          styles: Styles(raw: {'display': 'flex', 'gap': '8px', 'margin-bottom': '12px'}),
          [dot('#ff5f56'), dot('#ffbd2e'), dot('#27c93f')],
        ),
        Component.element(
          tag: 'pre',
          styles: Styles(raw: {
            'margin': '0',
            'color': '#cbd5e1',
            'font-family': 'ui-monospace, SFMono-Regular, Menlo, monospace',
            'font-size': '13px',
            'line-height': '1.6',
            'white-space': 'pre-wrap',
          }),
          children: [.text(code)],
        ),
      ],
    );
  }
}
