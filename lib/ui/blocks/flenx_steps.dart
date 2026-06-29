import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';
import '../flenx_animated.dart';
import '../flenx_card.dart';
import '../flenx_column.dart';
import '../flenx_grid.dart';
import '../flenx_heading.dart';
import '../flenx_section.dart';
import '../flenx_text.dart';
import '../flenx_ui_enums.dart';

/// Um passo do "como funciona".
class FlenxStep {
  const FlenxStep(this.title, this.description);
  final String title;
  final String description;
}

/// Seção de passos numerados. `FlenxSteps(title: '...', steps: [FlenxStep(...)])`.
class FlenxSteps extends StatelessComponent {
  const FlenxSteps({
    required this.steps,
    this.eyebrow,
    this.title,
    this.background,
    this.badgeColor = FlenxPalette.primary,
    this.animate = false,
    this.id,
    super.key,
  });

  final List<FlenxStep> steps;
  final String? eyebrow;
  final String? title;
  final String? background;
  final String badgeColor;

  /// Ativa scroll-reveal nos textos de cabeçalho e em cada passo.
  final bool animate;
  final String? id;

  Component _badge(int n) => div(
        styles: Styles(raw: {
          'width': '38px',
          'height': '38px',
          'border-radius': '10px',
          'background': badgeColor,
          'color': '#fff',
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'center',
          'font-weight': '800',
        }),
        [.text('$n')],
      );

  Component _a(Component child, FlenxAnimation anim, int delay) => animate
      ? FlenxAnimated(child, animation: anim, delay: delay)
      : child;

  @override
  Component build(BuildContext context) {
    return FlenxSection(
      id: id,
      background: background,
      child: FlenxColumn(
        gap: 36,
        cross: FlenxAlign.stretch,
        [
          if (eyebrow != null)
            _a(FlenxText(eyebrow!, align: FlenxTextAlign.center, color: 'var(--primary, ${FlenxPalette.primary})', weight: 700), FlenxAnimation.slideUp, 0),
          if (title != null)
            _a(FlenxHeading(title!, align: FlenxTextAlign.center), FlenxAnimation.slideUp, 100),
          FlenxGrid(
            minItemWidth: 260,
            [
              for (var i = 0; i < steps.length; i++)
                _a(
                  FlenxCard(
                    FlenxColumn(gap: 10, [
                      _badge(i + 1),
                      FlenxHeading(steps[i].title, level: 3),
                      FlenxText(steps[i].description, color: FlenxPalette.muted),
                    ]),
                    background: FlenxPalette.surface,
                  ),
                  FlenxAnimation.slideUp,
                  100 + i * 120,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
