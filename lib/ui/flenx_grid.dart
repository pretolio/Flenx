import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'flenx_animated.dart';
import 'flenx_animation.dart';
import 'flenx_ui_enums.dart';

/// Grade responsiva — coloca os filhos lado a lado e quebra a linha sozinha
/// quando a tela estreita (cada item tem largura mínima [minItemWidth]).
/// Substitui aqueles `div(flex: ...)` na mão: você só passa os componentes.
///
/// Com [animation], cada item recebe um scroll-reveal escalonado (stagger).
class FlenxGrid extends StatelessComponent {
  const FlenxGrid(
    this.children, {
    this.minItemWidth = 280,
    this.gap = 20,
    this.main = FlenxAlign.center,
    this.animation,
    this.animationDelay = 0,
    this.animationDuration = 600,
    this.animationStagger = 80,
    super.key,
  });

  final List<Component> children;
  final double minItemWidth;
  final double gap;
  final FlenxAlign main;

  /// Tipo de animação aplicada a cada item. `null` = sem animação.
  final FlenxAnimation? animation;

  /// Atraso inicial antes do primeiro item animar (ms).
  final int animationDelay;

  /// Duração da animação de cada item (ms).
  final int animationDuration;

  /// Atraso adicional entre cada item (ms).
  final int animationStagger;

  Component _wrap(Component child, int index) {
    if (animation == null) return child;
    return FlenxAnimated(
      child,
      animation: animation!,
      delay: animationDelay + index * animationStagger,
      duration: animationDuration,
    );
  }

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
        for (var i = 0; i < children.length; i++)
          div(
            styles: Styles(raw: {
              'flex': '1 1 ${minItemWidth}px',
              'max-width': '100%',
            }),
            [_wrap(children[i], i)],
          ),
      ],
    );
  }
}
