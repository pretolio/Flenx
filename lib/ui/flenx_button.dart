import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_palette.dart';
import 'flenx_animated.dart';
import 'flenx_ui_enums.dart';

/// Botão/link — como um `ElevatedButton`/`TextButton`. Aponta para [href].
/// Tem **hover predefinido** (clareia + sobe levemente) ativado por padrão; é
/// só um parâmetro Dart ([hover]) — você nunca escreve CSS. O componente injeta
/// o `:hover` scoped por baixo (inline não faz `:hover`).
class FlenxButton extends StatelessComponent {
  const FlenxButton(
    this.label, {
    required this.href,
    this.variant = FlenxButtonVariant.primary,
    this.color,
    this.newTab = false,
    this.hover = true,
    this.animation,
    this.animationDelay = 0,
    this.animationDuration = 600,
    super.key,
  });

  final String label;
  final String href;
  final FlenxButtonVariant variant;

  /// Sobrescreve a cor de acento usada pelo variant (ghost/soft usam primary por padrão).
  final String? color;
  final bool newTab;

  /// Efeito de hover predefinido. `false` desliga.
  final bool hover;

  /// Anima o botão com scroll-reveal. `null` = sem animação.
  final FlenxAnimation? animation;
  final int animationDelay;
  final int animationDuration;

  Map<String, String> get _variantStyles {
    final accent = color ?? 'var(--primary, ${FlenxPalette.primary})';
    return switch (variant) {
      FlenxButtonVariant.primary => {'background': accent, 'color': '#ffffff'},
      FlenxButtonVariant.ghost => {
        'background': 'transparent',
        'color': accent,
        'box-shadow': 'inset 0 0 0 1.5px $accent',
      },
      FlenxButtonVariant.soft => {
        'background': FlenxPalette.surface,
        'color': accent,
      },
    };
  }

  @override
  Component build(BuildContext context) {
    final cls = 'fbtn-${variant.name}';
    final link = a(
      [.text(label)],
      href: href,
      classes: hover ? cls : null,
      target: newTab ? Target.blank : null,
      attributes: newTab ? {'rel': 'noopener noreferrer'} : null,
      styles: Styles(
        raw: {
          'display': 'inline-block',
          'padding': '12px 22px',
          'border-radius': '10px',
          'font-weight': '700',
          'text-decoration': 'none',
          'cursor': 'pointer',
          'transition': 'filter .15s ease, transform .15s ease',
          ..._variantStyles,
        },
      ),
    );
    Component result = link;
    if (hover) {
      result = span(styles: Styles(raw: {'display': 'inline-block'}), [
        Component.element(
          tag: 'style',
          children: [
            RawText(
              '.$cls:hover{filter:brightness(1.06);transform:translateY(-1px)}',
            ),
          ],
        ),
        link,
      ]);
    }
    if (animation != null) {
      return FlenxAnimated(
        result,
        animation: animation!,
        delay: animationDelay,
        duration: animationDuration,
      );
    }
    return result;
  }
}
