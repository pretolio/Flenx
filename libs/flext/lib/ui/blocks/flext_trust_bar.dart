import 'package:jaspr/jaspr.dart';

import '../../flext_palette.dart';
import '../flext_row.dart';
import '../flext_section.dart';
import '../flext_text.dart';
import '../flext_ui_enums.dart';

/// Barra de "construído sobre / parceiros": um rótulo opcional + uma lista de
/// nomes em destaque. Substitui aquele bloco de `div/span` por puro Dart:
/// `FlextTrustBar(label: 'Construído sobre', items: ['jaspr','Flutter','Dart'])`.
class FlextTrustBar extends StatelessComponent {
  const FlextTrustBar({
    required this.items,
    this.label,
    this.background = FlextPalette.surface,
    super.key,
  });

  final List<String> items;
  final String? label;
  final String background;

  @override
  Component build(BuildContext context) {
    return FlextSection(
      background: background,
      paddingY: 26,
      child: FlextRow(
        gap: 26,
        wrap: true,
        cross: FlextAlign.center,
        main: FlextAlign.center,
        [
          if (label != null) FlextText(label!, color: FlextPalette.muted),
          for (final it in items)
            FlextText(it, weight: 700, color: FlextPalette.ink),
        ],
      ),
    );
  }
}
