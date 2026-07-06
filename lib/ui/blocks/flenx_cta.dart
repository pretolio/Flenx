import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';
import '../flenx_button.dart';
import '../flenx_card.dart';
import '../flenx_column.dart';
import '../flenx_heading.dart';
import '../flenx_section.dart';
import '../flenx_text.dart';
import '../flenx_ui_enums.dart';

/// Chamada para ação (CTA): título, subtítulo e um botão, num cartão centrado.
class FlenxCta extends StatelessComponent {
  const FlenxCta({required this.title, this.subtitle, this.action, super.key});

  final String title;
  final String? subtitle;
  final FlenxButton? action;

  @override
  Component build(BuildContext context) {
    return FlenxSection(
      child: FlenxCard(
        FlenxColumn(
          gap: 14,
          cross: FlenxAlign.center,
          main: FlenxAlign.center,
          [
            FlenxHeading(title, align: FlenxTextAlign.center),
            if (subtitle != null)
              FlenxText(
                subtitle!,
                align: FlenxTextAlign.center,
                color: FlenxPalette.muted,
              ),
            if (action != null) action!,
          ],
        ),
        padding: 48,
        background: FlenxPalette.surface,
      ),
    );
  }
}
