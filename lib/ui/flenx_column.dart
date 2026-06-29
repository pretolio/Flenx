import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'flenx_animated.dart';
import 'flenx_animation.dart';
import 'flenx_ui_enums.dart';

/// Coluna (vertical) — como o `Column` do Flutter. [gap] é o espaço entre os
/// filhos (px). Gera flexbox por baixo; você não escreve CSS.
///
/// Com [animation], cada filho recebe um scroll-reveal escalonado (stagger).
class FlenxColumn extends StatelessComponent {
  const FlenxColumn(
    this.children, {
    this.gap = 0,
    this.cross = FlenxAlign.start,
    this.main = FlenxAlign.start,
    this.maxWidthPx,
    this.animation,
    this.animationDelay = 0,
    this.animationDuration = 600,
    this.animationStagger = 80,
    super.key,
  });

  final List<Component> children;
  final double gap;
  final FlenxAlign cross;
  final FlenxAlign main;
  final double? maxWidthPx;

  /// Tipo de animação aplicada a cada filho. `null` = sem animação.
  final FlenxAnimation? animation;

  /// Atraso inicial antes do primeiro filho animar (ms).
  final int animationDelay;

  /// Duração da animação de cada filho (ms).
  final int animationDuration;

  /// Atraso adicional entre cada filho (ms).
  final int animationStagger;

  List<Component> get _kids {
    if (animation == null) return children;
    return [
      for (var i = 0; i < children.length; i++)
        FlenxAnimated(
          children[i],
          animation: animation!,
          delay: animationDelay + i * animationStagger,
          duration: animationDuration,
        ),
    ];
  }

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
      _kids,
    );
  }
}
