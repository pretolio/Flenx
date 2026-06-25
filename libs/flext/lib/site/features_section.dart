import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flext_palette.dart';
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
    return FlextSection(
      id: 'recursos',
      child: FlextColumn(
        gap: 14,
        cross: FlextAlign.stretch,
        [
          FlextText(eyebrow,
              align: FlextTextAlign.center,
              color: FlextPalette.primary,
              weight: 700),
          FlextHeading(title, align: FlextTextAlign.center),
          FlextText(subtitle,
              align: FlextTextAlign.center, color: FlextPalette.muted),
          FlextRow(
            gap: 20,
            wrap: true,
            cross: FlextAlign.stretch,
            main: FlextAlign.center,
            [
              for (final f in features)
                div(
                  styles:
                      Styles(raw: {'flex': '1 1 300px', 'max-width': '360px'}),
                  [
                    FlextCard(
                      FlextColumn(gap: 10, [
                        _icon(f.icon),
                        FlextHeading(f.title, level: 3),
                        FlextText(f.description, color: FlextPalette.muted),
                      ]),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
