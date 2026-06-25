import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'flext_ui_enums.dart';

/// Coluna (vertical) — como o `Column` do Flutter. [gap] é o espaço entre os
/// filhos (px). Gera flexbox por baixo; você não escreve CSS.
class FlextColumn extends StatelessComponent {
  const FlextColumn(
    this.children, {
    this.gap = 0,
    this.cross = FlextAlign.start,
    this.main = FlextAlign.start,
    this.maxWidthPx,
    super.key,
  });

  final List<Component> children;
  final double gap;
  final FlextAlign cross;
  final FlextAlign main;
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
