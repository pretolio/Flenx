import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_palette.dart';
import '../ui/ui.dart';
import 'models/feature.dart';

/// Seção de recursos — grade de cards (ícone, título, descrição), montada com o
/// kit Dart (sem HTML/CSS). Textos e [features] são personalizáveis.
class FeaturesSection extends StatelessComponent {
  const FeaturesSection({
    required this.features,
    this.eyebrow = 'Recursos',
    this.title = 'Tudo que um site moderno precisa',
    this.subtitle =
        'Pré-configurado e pronto para produção — e 100% personalizável.',
    this.id = 'servicos',
    this.cardHover,
    this.cardGlowColor = FlenxPalette.primary,
    this.animate = false,
    super.key,
  });

  final List<Feature> features;
  final String eyebrow;
  final String title;
  final String subtitle;
  final String id;

  /// Efeito de hover nos cards. `null` = sem hover.
  final FlenxCardHover? cardHover;

  /// Cor do brilho quando [cardHover] é [FlenxCardHover.glow].
  final String cardGlowColor;

  /// Ativa scroll-reveal nas entradas do cabeçalho e em cada card.
  final bool animate;

  Component _icon(String emoji) => div(
        styles: Styles(raw: {
          'width': '46px',
          'height': '46px',
          'border-radius': '12px',
          'background': 'rgba(1,88,155,.10)',
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'center',
          'font-size': '22px',
        }),
        [.text(emoji)],
      );

  Component _a(Component child, FlenxAnimation anim, int delay) => animate
      ? FlenxAnimated(child, animation: anim, delay: delay)
      : child;

  @override
  Component build(BuildContext context) {
    return FlenxSection(
      id: id,
      child: FlenxColumn(
        gap: 14,
        cross: FlenxAlign.stretch,
        [
          _a(FlenxText(eyebrow, align: FlenxTextAlign.center, color: 'var(--primary, ${FlenxPalette.primary})', weight: 700), FlenxAnimation.slideUp, 0),
          _a(FlenxHeading(title, align: FlenxTextAlign.center), FlenxAnimation.slideUp, 100),
          _a(FlenxText(subtitle, align: FlenxTextAlign.center, color: FlenxPalette.muted), FlenxAnimation.fadeIn, 200),
          FlenxGrid(
            minItemWidth: 300,
            [
              for (var i = 0; i < features.length; i++)
                _a(
                  FlenxCard(
                    FlenxColumn(gap: 10, [
                      _icon(features[i].icon),
                      FlenxHeading(features[i].title, level: 3),
                      FlenxText(features[i].description, color: FlenxPalette.muted),
                    ]),
                    hover: cardHover,
                    glowColor: cardGlowColor,
                  ),
                  FlenxAnimation.slideUp,
                  100 + i * 80,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
