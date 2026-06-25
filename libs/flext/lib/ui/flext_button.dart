import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flext_palette.dart';
import 'flext_ui_enums.dart';

/// Botão/link — como um `ElevatedButton`/`TextButton`. Aponta para [href]
/// (rota interna ou URL). Estilo por [variant]; nada de CSS.
class FlextButton extends StatelessComponent {
  const FlextButton(
    this.label, {
    required this.href,
    this.variant = FlextButtonVariant.primary,
    this.newTab = false,
    super.key,
  });

  final String label;
  final String href;
  final FlextButtonVariant variant;
  final bool newTab;

  Map<String, String> get _variantStyles => switch (variant) {
        FlextButtonVariant.primary => {
            'background': FlextPalette.primary,
            'color': '#ffffff',
          },
        FlextButtonVariant.ghost => {
            'background': 'transparent',
            'color': FlextPalette.primary,
            'box-shadow': 'inset 0 0 0 1.5px ${FlextPalette.primary}',
          },
        FlextButtonVariant.soft => {
            'background': FlextPalette.surface,
            'color': FlextPalette.primary,
          },
      };

  @override
  Component build(BuildContext context) {
    return a(
      [.text(label)],
      href: href,
      target: newTab ? Target.blank : null,
      attributes: newTab ? {'rel': 'noopener noreferrer'} : null,
      styles: Styles(raw: {
        'display': 'inline-block',
        'padding': '12px 22px',
        'border-radius': '10px',
        'font-weight': '700',
        'text-decoration': 'none',
        'cursor': 'pointer',
        ..._variantStyles,
      }),
    );
  }
}
