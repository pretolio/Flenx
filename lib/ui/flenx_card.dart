import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_palette.dart';
import 'flenx_animated.dart';
import 'flenx_animation.dart';
import 'flenx_card_hover.dart';

export 'flenx_card_hover.dart';

/// Cartão — um contêiner com fundo, borda e cantos arredondados (como um
/// `Card`/`Container` do Flutter). Estilo por parâmetros; nada de CSS.
///
/// Com [backgroundImage], a imagem aparece atrás do conteúdo. O parâmetro
/// [background] (cor) fica como overlay sobre a imagem.
class FlenxCard extends StatelessComponent {
  const FlenxCard(
    this.child, {
    this.padding = 20,
    this.radius = 16,
    this.background = '#ffffff',
    this.backgroundImage,
    this.backgroundImageOpacity = 0.3,
    this.borderColor = FlenxPalette.border,
    this.bordered = true,
    this.hover,
    this.glowColor = FlenxPalette.primary,
    this.animation,
    this.animationDelay = 0,
    this.animationDuration = 600,
    super.key,
  });

  final Component child;
  final double padding;
  final double radius;

  /// Cor de fundo do card. Quando há [backgroundImage], atua como overlay.
  final String background;

  /// URL da imagem de fundo (ex.: `'/assets/texture.jpg'`).
  final String? backgroundImage;

  /// Opacidade da imagem de fundo — de `0.0` a `1.0`.
  final double backgroundImageOpacity;

  final String borderColor;
  final bool bordered;

  /// Efeito ao passar o mouse. `null` = sem hover.
  final FlenxCardHover? hover;

  /// Cor do brilho quando [hover] é [FlenxCardHover.glow].
  final String glowColor;

  /// Anima o card com scroll-reveal. `null` = sem animação.
  final FlenxAnimation? animation;
  final int animationDelay;
  final int animationDuration;

  String get _cls => switch (hover) {
        FlenxCardHover.lift => 'fcard-lift',
        FlenxCardHover.glow => 'fcard-glow-$_colorKey',
        FlenxCardHover.scale => 'fcard-scale',
        null => '',
      };

  String get _css => switch (hover) {
        FlenxCardHover.lift =>
          '.fcard-lift{transition:transform .2s ease,box-shadow .2s ease,border-color .2s ease}'
          '.fcard-lift:hover{transform:translateY(-4px);box-shadow:0 8px 28px rgba(0,0,0,.10);border-color:#c8d8ea}',
        FlenxCardHover.glow =>
          '.fcard-glow-${_colorKey}{transition:box-shadow .3s ease}'
          '.fcard-glow-${_colorKey}:hover{box-shadow:0 0 18px 4px $_glowRgba,0 0 40px 10px ${_glowRgbaFaint}}',
        FlenxCardHover.scale =>
          '.fcard-scale{transition:transform .2s ease,box-shadow .2s ease}'
          '.fcard-scale:hover{transform:scale(1.03);box-shadow:0 6px 22px rgba(0,0,0,.09)}',
        null => '',
      };

  /// Chave única da cor para o nome da classe CSS (evita conflito entre cores).
  String get _colorKey => glowColor.replaceAll('#', '').toLowerCase();

  /// Cor rgba do brilho interno com 45% de opacidade.
  String get _glowRgba {
    final h = glowColor.replaceAll('#', '');
    if (h.length == 6) {
      final r = int.parse(h.substring(0, 2), radix: 16);
      final g = int.parse(h.substring(2, 4), radix: 16);
      final b = int.parse(h.substring(4, 6), radix: 16);
      return 'rgba($r,$g,$b,.45)';
    }
    return '${glowColor}73';
  }

  /// Cor rgba do halo externo com 15% de opacidade.
  String get _glowRgbaFaint {
    final h = glowColor.replaceAll('#', '');
    if (h.length == 6) {
      final r = int.parse(h.substring(0, 2), radix: 16);
      final g = int.parse(h.substring(2, 4), radix: 16);
      final b = int.parse(h.substring(4, 6), radix: 16);
      return 'rgba($r,$g,$b,.15)';
    }
    return '${glowColor}26';
  }

  @override
  Component build(BuildContext context) {
    Component card;

    if (backgroundImage != null) {
      // Card com imagem de fundo: outer div (position relative) + layers
      card = div(
        classes: hover != null ? _cls : null,
        styles: Styles(raw: {
          'position': 'relative',
          'overflow': 'hidden',
          'border-radius': '${radius}px',
          if (bordered) 'border': '1px solid $borderColor',
        }),
        [
          // Camada da imagem
          div(
            styles: Styles(raw: {
              'position': 'absolute',
              'inset': '0',
              'background-image': 'url($backgroundImage)',
              'background-size': 'cover',
              'background-position': 'center',
              'opacity': '$backgroundImageOpacity',
            }),
            [],
          ),
          // Overlay de cor
          div(
            styles: Styles(raw: {
              'position': 'absolute',
              'inset': '0',
              'background': background,
            }),
            [],
          ),
          // Conteúdo
          div(
            styles: Styles(raw: {
              'position': 'relative',
              'z-index': '1',
              'padding': '${padding}px',
            }),
            [child],
          ),
        ],
      );
    } else {
      card = div(
        classes: hover != null ? _cls : null,
        styles: Styles(raw: {
          'background': background,
          'padding': '${padding}px',
          'border-radius': '${radius}px',
          if (bordered) 'border': '1px solid $borderColor',
        }),
        [child],
      );
    }

    Component result = card;
    if (hover != null) {
      result = span(styles: Styles(raw: {'display': 'contents'}), [
        Component.element(tag: 'style', children: [RawText(_css)]),
        card,
      ]);
    }
    if (animation != null) {
      return FlenxAnimated(result, animation: animation!, delay: animationDelay, duration: animationDuration);
    }
    return result;
  }
}
