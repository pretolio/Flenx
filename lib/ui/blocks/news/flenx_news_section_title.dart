import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../flenx_palette.dart';

/// Título de bloco/editoria (estilo G1): texto com barra à esquerda na cor
/// primária (`var(--primary)`).
class FlenxNewsSectionTitle extends StatelessComponent {
  const FlenxNewsSectionTitle(this.label, {super.key});

  final String label;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(
        raw: {
          'display': 'flex',
          'align-items': 'center',
          'gap': '10px',
          'margin': '0 0 16px',
        },
      ),
      [
        span(
          styles: Styles(
            raw: {
              'width': '5px',
              'height': '22px',
              'background': 'var(--primary)',
              'border-radius': '2px',
              'display': 'inline-block',
            },
          ),
          [],
        ),
        span(
          styles: Styles(
            raw: {
              'font-size': '20px',
              'font-weight': '800',
              'color': FlenxPalette.ink,
            },
          ),
          [Component.text(label)],
        ),
      ],
    );
  }
}
