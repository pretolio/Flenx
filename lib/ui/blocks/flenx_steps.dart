import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';
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
    super.key,
  });

  final List<FlenxStep> steps;
  final String? eyebrow;
  final String? title;
  final String? background;

  Component _badge(int n) => div(
        styles: Styles(raw: {
          'width': '38px',
          'height': '38px',
          'border-radius': '10px',
          'background': FlenxPalette.primary,
          'color': '#fff',
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'center',
          'font-weight': '800',
        }),
        [.text('$n')],
      );

  @override
  Component build(BuildContext context) {
    return FlenxSection(
      background: background,
      child: FlenxColumn(
        gap: 36,
        cross: FlenxAlign.stretch,
        [
          if (eyebrow != null)
            FlenxText(eyebrow!,
                align: FlenxTextAlign.center,
                color: FlenxPalette.primary,
                weight: 700),
          if (title != null)
            FlenxHeading(title!, align: FlenxTextAlign.center),
          FlenxGrid(
            minItemWidth: 260,
            [
              for (var i = 0; i < steps.length; i++)
                FlenxCard(
                  FlenxColumn(gap: 10, [
                    _badge(i + 1),
                    FlenxHeading(steps[i].title, level: 3),
                    FlenxText(steps[i].description, color: FlenxPalette.muted),
                  ]),
                  background: FlenxPalette.surface,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
