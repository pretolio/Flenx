import 'package:jaspr/jaspr.dart';

import '../../flext_palette.dart';
import '../flext_button.dart';
import '../flext_card.dart';
import '../flext_column.dart';
import '../flext_heading.dart';
import '../flext_section.dart';
import '../flext_text.dart';
import '../flext_ui_enums.dart';

/// Chamada para ação (CTA): título, subtítulo e um botão, num cartão centrado.
class FlextCta extends StatelessComponent {
  const FlextCta({
    required this.title,
    this.subtitle,
    this.action,
    super.key,
  });

  final String title;
  final String? subtitle;
  final FlextButton? action;

  @override
  Component build(BuildContext context) {
    return FlextSection(
      child: FlextCard(
        FlextColumn(
          gap: 14,
          cross: FlextAlign.center,
          main: FlextAlign.center,
          [
            FlextHeading(title, align: FlextTextAlign.center),
            if (subtitle != null)
              FlextText(subtitle!,
                  align: FlextTextAlign.center, color: FlextPalette.muted),
            if (action != null) action!,
          ],
        ),
        padding: 48,
        background: FlextPalette.surface,
      ),
    );
  }
}
