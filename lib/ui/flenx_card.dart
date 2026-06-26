import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_palette.dart';

/// Cartão — um contêiner com fundo, borda e cantos arredondados (como um
/// `Card`/`Container` do Flutter). Estilo por parâmetros; nada de CSS.
class FlenxCard extends StatelessComponent {
  const FlenxCard(
    this.child, {
    this.padding = 20,
    this.radius = 16,
    this.background = '#ffffff',
    this.borderColor = FlenxPalette.border,
    this.bordered = true,
    super.key,
  });

  final Component child;
  final double padding;
  final double radius;
  final String background;
  final String borderColor;
  final bool bordered;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(raw: {
        'background': background,
        'padding': '${padding}px',
        'border-radius': '${radius}px',
        if (bordered) 'border': '1px solid $borderColor',
      }),
      [child],
    );
  }
}
