import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'flext_ui_enums.dart';

/// Linha (horizontal) — como o `Row` do Flutter. Com [wrap] `true`, quebra para
/// baixo quando a tela é estreita (responsivo automático, sem media query).
class FlextRow extends StatelessComponent {
  const FlextRow(
    this.children, {
    this.gap = 0,
    this.cross = FlextAlign.center,
    this.main = FlextAlign.start,
    this.wrap = false,
    super.key,
  });

  final List<Component> children;
  final double gap;
  final FlextAlign cross;
  final FlextAlign main;
  final bool wrap;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(raw: {
        'display': 'flex',
        'flex-direction': 'row',
        if (wrap) 'flex-wrap': 'wrap',
        'gap': '${gap}px',
        'align-items': cross.css,
        'justify-content': main.css,
      }),
      children,
    );
  }
}
