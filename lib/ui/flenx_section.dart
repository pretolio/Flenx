import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'flenx_animated.dart';

/// Seção da página — uma faixa com espaçamento vertical e um contêiner central
/// de largura máxima (como um bloco de tela). Estilo por parâmetros; sem CSS.
///
/// Com [animation], o filho inteiro entra com scroll-reveal.
/// Com [backgroundImage], a imagem aparece atrás do conteúdo com [backgroundImageOpacity].
/// O parâmetro [background] (cor/gradiente) fica como overlay acima da imagem.
class FlenxSection extends StatelessComponent {
  const FlenxSection({
    required this.child,
    this.background,
    this.backgroundImage,
    this.backgroundImageOpacity = 0.3,
    this.paddingY = 72,
    this.maxWidthPx = 1120,
    this.id,
    this.animation,
    this.animationDelay = 0,
    this.animationDuration = 600,
    super.key,
  });

  final Component child;

  /// Cor/gradiente de fundo (hex ou valor CSS). Quando há [backgroundImage],
  /// atua como overlay sobre a imagem.
  final String? background;

  /// URL da imagem de fundo (ex.: `'/assets/bg.jpg'`).
  final String? backgroundImage;

  /// Opacidade da imagem de fundo — de `0.0` (invisível) a `1.0` (opaca).
  final double backgroundImageOpacity;

  final double paddingY;
  final double maxWidthPx;
  final String? id;

  /// Tipo de animação aplicada ao conteúdo da seção. `null` = sem animação.
  final FlenxAnimation? animation;

  /// Atraso antes da animação (ms).
  final int animationDelay;

  /// Duração da animação (ms).
  final int animationDuration;

  @override
  Component build(BuildContext context) {
    final content = animation != null
        ? FlenxAnimated(child, animation: animation!, delay: animationDelay, duration: animationDuration)
        : child;

    final innerDiv = div(
      styles: Styles(raw: {
        'max-width': '${maxWidthPx}px',
        'margin': '0 auto',
        if (backgroundImage != null) 'position': 'relative',
        if (backgroundImage != null) 'z-index': '1',
      }),
      [content],
    );

    if (backgroundImage == null) {
      return Component.element(
        tag: 'section',
        id: id,
        styles: Styles(raw: {
          'padding': '${paddingY}px 24px',
          if (background != null) 'background': background!,
        }),
        children: [innerDiv],
      );
    }

    return Component.element(
      tag: 'section',
      id: id,
      styles: Styles(raw: {
        'padding': '${paddingY}px 24px',
        'position': 'relative',
        'overflow': 'hidden',
      }),
      children: [
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
        // Overlay de cor (opcional — ex.: 'rgba(0,0,0,0.6)' para escurecer)
        if (background != null)
          div(
            styles: Styles(raw: {
              'position': 'absolute',
              'inset': '0',
              'background': background!,
            }),
            [],
          ),
        // Conteúdo
        innerDiv,
      ],
    );
  }
}
