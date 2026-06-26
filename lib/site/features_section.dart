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
    super.key,
  });

  final List<Feature> features;
  final String eyebrow;
  final String title;
  final String subtitle;

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

  @override
  Component build(BuildContext context) {
    return FlenxSection(
      id: 'recursos',
      child: FlenxColumn(
        gap: 14,
        cross: FlenxAlign.stretch,
        [
          FlenxText(eyebrow,
              align: FlenxTextAlign.center,
              color: FlenxPalette.primary,
              weight: 700),
          FlenxHeading(title, align: FlenxTextAlign.center),
          FlenxText(subtitle,
              align: FlenxTextAlign.center, color: FlenxPalette.muted),
          FlenxGrid(
            minItemWidth: 300,
            [
              for (final f in features)
                FlenxCard(
                  FlenxColumn(gap: 10, [
                    _icon(f.icon),
                    FlenxHeading(f.title, level: 3),
                    FlenxText(f.description, color: FlenxPalette.muted),
                  ]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
