import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'flenx_ui_enums.dart';

/// Linha (horizontal) — como o `Row` do Flutter. Com [wrap] `true`, quebra para
/// baixo quando a tela é estreita (responsivo automático, sem media query).
class FlenxRow extends StatelessComponent {
  const FlenxRow(
    this.children, {
    this.gap = 0,
    this.cross = FlenxAlign.center,
    this.main = FlenxAlign.start,
    this.wrap = false,
    super.key,
  });

  final List<Component> children;
  final double gap;
  final FlenxAlign cross;
  final FlenxAlign main;
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
