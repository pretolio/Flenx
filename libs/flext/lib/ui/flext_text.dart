import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'flext_ui_enums.dart';

/// Texto — como o `Text` do Flutter, com estilo por parâmetros (nada de CSS).
class FlextText extends StatelessComponent {
  const FlextText(
    this.data, {
    this.size = 16,
    this.weight = 400,
    this.color,
    this.align,
    this.maxWidthPx,
    this.lineHeight,
    super.key,
  });

  final String data;
  final double size;
  final int weight;

  /// Cor em hex (ex.: `FlextPalette.ink`). Nulo = herda.
  final String? color;
  final FlextTextAlign? align;
  final double? maxWidthPx;
  final double? lineHeight;

  @override
  Component build(BuildContext context) {
    return p(
      styles: Styles(raw: {
        'margin': '0',
        'font-size': '${size}px',
        'font-weight': '$weight',
        if (color != null) 'color': color!,
        if (align != null) 'text-align': align!.name,
        if (maxWidthPx != null) 'max-width': '${maxWidthPx}px',
        if (lineHeight != null) 'line-height': '$lineHeight',
      }),
      [.text(data)],
    );
  }
}
