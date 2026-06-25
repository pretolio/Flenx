import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'flext_ui_enums.dart';

/// Grade responsiva — coloca os filhos lado a lado e quebra a linha sozinha
/// quando a tela estreita (cada item tem largura mínima [minItemWidth]).
/// Substitui aqueles `div(flex: ...)` na mão: você só passa os componentes.
class FlextGrid extends StatelessComponent {
  const FlextGrid(
    this.children, {
    this.minItemWidth = 280,
    this.gap = 20,
    this.main = FlextAlign.center,
    super.key,
  });

  final List<Component> children;
  final double minItemWidth;
  final double gap;
  final FlextAlign main;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(raw: {
        'display': 'flex',
        'flex-wrap': 'wrap',
        'gap': '${gap}px',
        'justify-content': main.css,
        'align-items': 'stretch',
      }),
      [
        for (final c in children)
          div(
            styles: Styles(raw: {
              'flex': '1 1 ${minItemWidth}px',
              'max-width': '100%',
            }),
            [c],
          ),
      ],
    );
  }
}
