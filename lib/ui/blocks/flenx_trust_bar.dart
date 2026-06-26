import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';
import '../flenx_row.dart';
import '../flenx_section.dart';
import '../flenx_text.dart';
import '../flenx_ui_enums.dart';

/// Barra de "construído sobre / parceiros": um rótulo opcional + uma lista de
/// nomes em destaque. Substitui aquele bloco de `div/span` por puro Dart:
/// `FlenxTrustBar(label: 'Construído sobre', items: ['jaspr','Flutter','Dart'])`.
class FlenxTrustBar extends StatelessComponent {
  const FlenxTrustBar({
    required this.items,
    this.label,
    this.background = FlenxPalette.surface,
    super.key,
  });

  final List<String> items;
  final String? label;
  final String background;

  @override
  Component build(BuildContext context) {
    return FlenxSection(
      background: background,
      paddingY: 26,
      child: FlenxRow(
        gap: 26,
        wrap: true,
        cross: FlenxAlign.center,
        main: FlenxAlign.center,
        [
          if (label != null) FlenxText(label!, color: FlenxPalette.muted),
          for (final it in items)
            FlenxText(it, weight: 700, color: FlenxPalette.ink),
        ],
      ),
    );
  }
}
