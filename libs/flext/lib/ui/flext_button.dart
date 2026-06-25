import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flext_palette.dart';
import 'flext_ui_enums.dart';

/// Botão/link — como um `ElevatedButton`/`TextButton`. Aponta para [href].
/// Tem **hover predefinido** (clareia + sobe levemente) ativado por padrão; é
/// só um parâmetro Dart ([hover]) — você nunca escreve CSS. O componente injeta
/// o `:hover` scoped por baixo (inline não faz `:hover`).
class FlextButton extends StatelessComponent {
  const FlextButton(
    this.label, {
    required this.href,
    this.variant = FlextButtonVariant.primary,
    this.newTab = false,
    this.hover = true,
    super.key,
  });

  final String label;
  final String href;
  final FlextButtonVariant variant;
  final bool newTab;

  /// Efeito de hover predefinido. `false` desliga.
  final bool hover;

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
    final cls = 'fbtn-${variant.name}';
    final link = a(
      [.text(label)],
      href: href,
      classes: hover ? cls : null,
      target: newTab ? Target.blank : null,
      attributes: newTab ? {'rel': 'noopener noreferrer'} : null,
      styles: Styles(raw: {
        'display': 'inline-block',
        'padding': '12px 22px',
        'border-radius': '10px',
        'font-weight': '700',
        'text-decoration': 'none',
        'cursor': 'pointer',
        'transition': 'filter .15s ease, transform .15s ease',
        ..._variantStyles,
      }),
    );
    if (!hover) return link;
    // Injeta o :hover scoped (impossível inline) — predefinido.
    return span(styles: Styles(raw: {'display': 'inline-block'}), [
      Component.element(tag: 'style', children: [
        RawText('.$cls:hover{filter:brightness(1.06);transform:translateY(-1px)}'),
      ]),
      link,
    ]);
  }
}
