import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flext_palette.dart';
import '../flext_card.dart';
import '../flext_column.dart';
import '../flext_heading.dart';
import '../flext_row.dart';
import '../flext_section.dart';
import '../flext_text.dart';
import '../flext_ui_enums.dart';

/// Um passo do "como funciona".
class FlextStep {
  const FlextStep(this.title, this.description);
  final String title;
  final String description;
}

/// Seção de passos numerados. `FlextSteps(title: '...', steps: [FlextStep(...)])`.
class FlextSteps extends StatelessComponent {
  const FlextSteps({
    required this.steps,
    this.eyebrow,
    this.title,
    this.background,
    super.key,
  });

  final List<FlextStep> steps;
  final String? eyebrow;
  final String? title;
  final String? background;

  Component _badge(int n) => div(
        styles: Styles(raw: {
          'width': '38px',
          'height': '38px',
          'border-radius': '10px',
          'background': FlextPalette.primary,
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
    return FlextSection(
      background: background,
      child: FlextColumn(
        gap: 36,
        cross: FlextAlign.stretch,
        [
          if (eyebrow != null)
            FlextText(eyebrow!,
                align: FlextTextAlign.center,
                color: FlextPalette.primary,
                weight: 700),
          if (title != null)
            FlextHeading(title!, align: FlextTextAlign.center),
          FlextRow(
            gap: 20,
            wrap: true,
            cross: FlextAlign.stretch,
            main: FlextAlign.center,
            [
              for (var i = 0; i < steps.length; i++)
                div(
                  styles: Styles(raw: {'flex': '1 1 260px', 'max-width': '360px'}),
                  [
                    FlextCard(
                      FlextColumn(gap: 10, [
                        _badge(i + 1),
                        FlextHeading(steps[i].title, level: 3),
                        FlextText(steps[i].description,
                            color: FlextPalette.muted),
                      ]),
                      background: FlextPalette.surface,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
