import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'flenx_animated.dart';
import 'flenx_ui_enums.dart';

/// Texto — como o `Text` do Flutter, com estilo por parâmetros (nada de CSS).
class FlenxText extends StatelessComponent {
  const FlenxText(
    this.data, {
    this.size = 16,
    this.weight = 400,
    this.color,
    this.align,
    this.maxWidthPx,
    this.lineHeight,
    this.animation,
    this.animationDelay = 0,
    this.animationDuration = 600,
    super.key,
  });

  final String data;
  final double size;
  final int weight;

  /// Cor em hex (ex.: `FlenxPalette.ink`). Nulo = herda.
  final String? color;
  final FlenxTextAlign? align;
  final double? maxWidthPx;
  final double? lineHeight;

  /// Anima o texto com scroll-reveal. `null` = sem animação.
  final FlenxAnimation? animation;
  final int animationDelay;
  final int animationDuration;

  @override
  Component build(BuildContext context) {
    final elem = p(
      styles: Styles(
        raw: {
          'margin': '0',
          'font-size': '${size}px',
          'font-weight': '$weight',
          if (color != null) 'color': color!,
          if (align != null) 'text-align': align!.name,
          if (maxWidthPx != null) 'max-width': '${maxWidthPx}px',
          if (lineHeight != null) 'line-height': '$lineHeight',
        },
      ),
      [.text(data)],
    );
    if (animation == null) return elem;
    return FlenxAnimated(
      elem,
      animation: animation!,
      delay: animationDelay,
      duration: animationDuration,
    );
  }
}
