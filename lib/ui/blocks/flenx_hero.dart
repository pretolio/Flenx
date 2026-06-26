import 'package:jaspr/jaspr.dart';

import '../flenx_button.dart';
import '../flenx_column.dart';
import '../flenx_heading.dart';
import '../flenx_row.dart';
import '../flenx_section.dart';
import '../flenx_text.dart';
import '../flenx_ui_enums.dart';

/// Hero pronto da landing: olho ([eyebrow]), título, subtítulo, botões
/// ([actions]) e um conteúdo opcional à direita ([aside], ex.: FlenxCodeCard).
/// Tudo por parâmetros — você não escreve HTML/CSS.
class FlenxHero extends StatelessComponent {
  const FlenxHero({
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
  final List<FlenxButton> actions;
  final Component? aside;
  final String background;

  @override
  Component build(BuildContext context) {
    return FlenxSection(
      background: background,
      paddingY: 96,
      child: FlenxRow(
        gap: 48,
        wrap: true,
        cross: FlenxAlign.center,
        main: FlenxAlign.spaceBetween,
        [
          FlenxColumn(
            gap: 18,
            maxWidthPx: 560,
            [
              if (eyebrow != null)
                FlenxText(eyebrow!, color: '#7dd3fc', weight: 700),
              FlenxHeading(title, level: 1, color: '#ffffff', size: 46),
              if (subtitle != null)
                FlenxText(subtitle!,
                    size: 18, color: '#dbeafe', lineHeight: 1.6),
              if (actions.isNotEmpty)
                FlenxRow(gap: 12, wrap: true, actions),
            ],
          ),
          if (aside != null) aside!,
        ],
      ),
    );
  }
}
