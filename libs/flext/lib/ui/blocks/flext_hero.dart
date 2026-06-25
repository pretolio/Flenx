import 'package:jaspr/jaspr.dart';

import '../flext_button.dart';
import '../flext_column.dart';
import '../flext_heading.dart';
import '../flext_row.dart';
import '../flext_section.dart';
import '../flext_text.dart';
import '../flext_ui_enums.dart';

/// Hero pronto da landing: olho ([eyebrow]), título, subtítulo, botões
/// ([actions]) e um conteúdo opcional à direita ([aside], ex.: FlextCodeCard).
/// Tudo por parâmetros — você não escreve HTML/CSS.
class FlextHero extends StatelessComponent {
  const FlextHero({
    required this.title,
    this.eyebrow,
    this.subtitle,
    this.actions = const [],
    this.aside,
    this.background = 'linear-gradient(135deg, #01406F 0%, #01589B 100%)',
    super.key,
  });

  final String title;
  final String? eyebrow;
  final String? subtitle;
  final List<FlextButton> actions;
  final Component? aside;
  final String background;

  @override
  Component build(BuildContext context) {
    return FlextSection(
      background: background,
      paddingY: 96,
      child: FlextRow(
        gap: 48,
        wrap: true,
        cross: FlextAlign.center,
        main: FlextAlign.spaceBetween,
        [
          FlextColumn(
            gap: 18,
            maxWidthPx: 560,
            [
              if (eyebrow != null)
                FlextText(eyebrow!, color: '#7dd3fc', weight: 700),
              FlextHeading(title, level: 1, color: '#ffffff', size: 46),
              if (subtitle != null)
                FlextText(subtitle!,
                    size: 18, color: '#dbeafe', lineHeight: 1.6),
              if (actions.isNotEmpty)
                FlextRow(gap: 12, wrap: true, actions),
            ],
          ),
          if (aside != null) aside!,
        ],
      ),
    );
  }
}
