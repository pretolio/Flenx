import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'flenx_ui_enums.dart';

/// Coluna (vertical) — como o `Column` do Flutter. [gap] é o espaço entre os
/// filhos (px). Gera flexbox por baixo; você não escreve CSS.
class FlenxColumn extends StatelessComponent {
  const FlenxColumn(
    this.children, {
    this.gap = 0,
    this.cross = FlenxAlign.start,
    this.main = FlenxAlign.start,
    this.maxWidthPx,
    super.key,
  });

  final List<Component> children;
  final double gap;
  final FlenxAlign cross;
  final FlenxAlign main;
  final double? maxWidthPx;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(raw: {
        'display': 'flex',
        'flex-direction': 'column',
        'gap': '${gap}px',
        'align-items': cross.css,
        'justify-content': main.css,
        if (maxWidthPx != null) 'max-width': '${maxWidthPx}px',
      }),
      children,
    );
  }
}
